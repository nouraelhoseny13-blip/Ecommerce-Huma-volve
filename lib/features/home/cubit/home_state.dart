import 'package:equatable/equatable.dart';
import '../data/home_models.dart';

enum HomeStatus { loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final String query;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.loading,
    this.products = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.query = '',
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ProductModel>? products,
    List<CategoryModel>? categories,
    int? selectedCategoryId,
    bool clearCategory = false,
    String? query,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, products, categories, selectedCategoryId, query, errorMessage];
}
