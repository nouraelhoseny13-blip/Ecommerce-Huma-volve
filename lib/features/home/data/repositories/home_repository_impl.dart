import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      return Right(await remote.getCategories());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure('Something went wrong, please try again'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int? categoryId,
    String? title,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      return Right(
        await remote.getProducts(
          categoryId: categoryId,
          title: title,
          offset: offset,
          limit: limit,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure('Something went wrong, please try again'));
    }
  }
}