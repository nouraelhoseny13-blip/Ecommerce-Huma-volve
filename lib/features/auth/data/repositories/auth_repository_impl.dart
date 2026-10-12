import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, Unit>> login(String email, String password) async {
    try {
      final tokens = await remote.login(email, password);
      await local.saveTokens(tokens);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure('Network error, please try again'));
    }
  }

  @override
  Future<Either<Failure, Unit>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      await remote.register(name, email, password);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure('Network error, please try again'));
    }
    // After a successful sign up, log in automatically.
    return login(email, password);
  }

  @override
  Future<void> logout() => local.clearTokens();

  @override
  Future<String?> getToken() => local.getAccessToken();
}
