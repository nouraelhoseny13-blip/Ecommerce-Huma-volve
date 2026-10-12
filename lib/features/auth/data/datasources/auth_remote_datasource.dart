import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/auth_tokens_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> login(String email, String password);
  Future<void> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String _baseUrl = 'https://api.escuelajs.co/api/v1';
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<AuthTokensModel> login(String email, String password) async {
    final res = await client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return AuthTokensModel.fromJson(jsonDecode(res.body));
    }
    throw const ServerException('Invalid email or password');
  }

  @override
  Future<void> register(String name, String email, String password) async {
    final res = await client.post(
      Uri.parse('$_baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'avatar': 'https://picsum.photos/800',
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw const ServerException('Registration failed');
    }
  }
}
