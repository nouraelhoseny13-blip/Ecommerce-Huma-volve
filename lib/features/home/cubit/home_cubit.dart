import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/home_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService _service;

  HomeCubit({HomeService? service})
      : _service = service ?? HomeService(),
        super(const HomeState());

  /// Loads categories and products together.
  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final results = await Future.wait([
        _service.getCategories(),
        _service.getProducts(
          categoryId: state.selectedCategoryId,
          title: state.query,
        ),
      ]);
      emit(state.copyWith(
        status: HomeStatus.success,
        categories: results[0] as dynamic,
        products: results[1] as dynamic,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Something went wrong, please try again',
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
    try {
      final products = await _service.getProducts(
        categoryId: state.selectedCategoryId,
        title: state.query,
      );
      emit(state.copyWith(status: HomeStatus.success, products: products));
    } catch (_) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Something went wrong, please try again',
      ));
    }
  }
}
