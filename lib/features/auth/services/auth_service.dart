import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';
  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';

  /// Returns null on success, or an error message.
  Future<String?> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        await _saveTokens(data['access_token'], data['refresh_token']);
        return null;
      }
      return 'Invalid email or password';
    } catch (e) {
      return 'Network error, please try again';
    }
  }

  /// Creates the user, then logs in automatically.
  Future<String?> register(String name, String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'avatar': 'https://picsum.photos/800',
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return await login(email, password);
      }
      return 'Registration failed';
    } catch (e) {
      return 'Network error, please try again';
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final token = await getToken();
    if (token == null) return null;
    final res = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  Future<void> _saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    await prefs.setString(_refreshKey, refresh);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }
}
