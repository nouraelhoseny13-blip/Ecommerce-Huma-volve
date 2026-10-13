import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts({
    int? categoryId,
    String? title,
    int offset,
    int limit,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  static const String _baseUrl = 'https://api.escuelajs.co/api/v1';
  final http.Client client;

  HomeRemoteDataSourceImpl(this.client);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final res = await client.get(Uri.parse('$_baseUrl/categories'));
    if (res.statusCode != 200) {
      throw const ServerException('Failed to load categories');
    }
    final List data = jsonDecode(res.body);
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
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
    final uri = Uri.parse('$_baseUrl/products').replace(queryParameters: params);
    final res = await client.get(uri);
    if (res.statusCode != 200) {
      throw const ServerException('Failed to load products');
    }
    final List data = jsonDecode(res.body);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
