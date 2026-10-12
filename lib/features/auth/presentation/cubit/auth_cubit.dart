import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AuthState());

  Future<void> login(String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    final result = await loginUseCase(email, password);
    result.fold(
      (failure) => emit(
        AuthState(status: AuthStatus.failure, errorMessage: failure.message),
      ),
      (_) => emit(const AuthState(status: AuthStatus.success)),
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    final result = await registerUseCase(name, email, password);
    result.fold(
      (failure) => emit(
        AuthState(status: AuthStatus.failure, errorMessage: failure.message),
      ),
      (_) => emit(const AuthState(status: AuthStatus.success)),
    );
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(const AuthState());
  }
}
