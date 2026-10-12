import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home_models.dart';

class HomeService {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  Future<List<CategoryModel>> getCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/categories'));
    if (res.statusCode != 200) throw Exception('Failed to load categories');
    final List data = jsonDecode(res.body);
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    String? title,
    int offset = 0,
    int limit = 20,
  }) async {
    final params = <String, String>{
      'offset': '$offset',
      'limit': '$limit',
      if (categoryId != null) 'categoryId': '$categoryId',
      if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
    };
    final uri = Uri.parse('$baseUrl/products').replace(queryParameters: params);
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to load products');
    final List data = jsonDecode(res.body);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
