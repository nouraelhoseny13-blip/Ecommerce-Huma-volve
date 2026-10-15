import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  static const int pageSize = 10;

  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  int _requestId = 0;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(const HomeState());

  Future<void> loadHome() async {
    final requestId = ++_requestId;
    emit(state.copyWith(
      status: HomeStatus.loading,
      isLoadingMore: false,
      hasReachedMax: false,
    ));

    final categoriesFuture = getCategoriesUseCase();
    final productsFuture = getProductsUseCase(
      categoryId: state.selectedCategoryId,
      title: state.query,
      offset: 0,
      limit: pageSize,
    );
    final categoriesResult = await categoriesFuture;
    final productsResult = await productsFuture;
    if (isClosed || requestId != _requestId) return;

    String? error;
    var categories = state.categories;
    List<ProductEntity> products = const [];

    categoriesResult.fold(
      (failure) => error = failure.message,
      (data) => categories = data,
    );
    productsResult.fold(
      (failure) => error = failure.message,
      (data) => products = data,
    );

    if (error != null) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: error));
    } else {
      emit(state.copyWith(
        status: HomeStatus.success,
        categories: categories,
        products: products,
        hasReachedMax: products.length < pageSize,
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.status != HomeStatus.success ||
        state.isLoadingMore ||
        state.hasReachedMax) {
      return;
    }

    final requestId = _requestId;
    emit(state.copyWith(isLoadingMore: true));

    final result = await getProductsUseCase(
      categoryId: state.selectedCategoryId,
      title: state.query,
      offset: state.products.length,
      limit: pageSize,
    );
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (newProducts) => emit(state.copyWith(
        isLoadingMore: false,
        products: [...state.products, ...newProducts],
        hasReachedMax: newProducts.length < pageSize,
      )),
    );
  }

  Future<void> selectCategory(int? categoryId) async {
    emit(state.copyWith(
      selectedCategoryId: categoryId,
      clearCategory: categoryId == null,
    ));
    await _reloadProducts();
  }

  Future<void> search(String query) async {
    emit(state.copyWith(query: query));
    await _reloadProducts();
  }

  Future<void> _reloadProducts() async {
    final requestId = ++_requestId;
    emit(state.copyWith(
      status: HomeStatus.loading,
      isLoadingMore: false,
      hasReachedMax: false,
    ));

    final result = await getProductsUseCase(
      categoryId: state.selectedCategoryId,
      title: state.query,
      offset: 0,
      limit: pageSize,
    );
    if (isClosed || requestId != _requestId) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: HomeStatus.success,
        products: products,
        hasReachedMax: products.length < pageSize,
      )),
    );
  }
}