import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository repository;
  const GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() =>
      repository.getCategories();
}
