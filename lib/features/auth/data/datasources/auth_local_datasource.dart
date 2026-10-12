import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_tokens_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokensModel tokens);
  Future<String?> getAccessToken();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, tokens.accessToken);
    await prefs.setString(_refreshKey, tokens.refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  @override
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }
}
