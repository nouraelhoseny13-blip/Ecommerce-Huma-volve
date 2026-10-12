import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> login(String email, String password);
  Future<Either<Failure, Unit>> register(
    String name,
    String email,
    String password,
  );
  Future<void> logout();
  Future<String?> getToken();
}
