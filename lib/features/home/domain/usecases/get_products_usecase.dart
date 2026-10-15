import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository repository;
  const GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    int? categoryId,
    String? title,
    int offset = 0,
    int limit = 10,
  }) =>
      repository.getProducts(
        categoryId: categoryId,
        title: title,
        offset: offset,
        limit: limit,
      );
}