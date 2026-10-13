import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(const HomeState());

  /// Loads categories and products together.
  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final results = await Future.wait([
      getCategoriesUseCase(),
      getProductsUseCase(
        categoryId: state.selectedCategoryId,
        title: state.query,
      ),
    ]);

    final categoriesResult = results[0] as dynamic;
    final productsResult = results[1] as dynamic;

    String? error;
    var categories = state.categories;
    var products = state.products;

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
      ));
    }
  }

  /// Pass null to select "All".
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
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await getProductsUseCase(
      categoryId: state.selectedCategoryId,
      title: state.query,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: failure.message,
      )),
      (products) =>
          emit(state.copyWith(status: HomeStatus.success, products: products)),
    );
  }
}
