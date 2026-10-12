import '../repositories/auth_repository.dart';

class GetTokenUseCase {
  final AuthRepository repository;
  const GetTokenUseCase(this.repository);

  Future<String?> call() => repository.getToken();
}
