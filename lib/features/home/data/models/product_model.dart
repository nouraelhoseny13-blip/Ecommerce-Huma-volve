import '../../domain/entities/product_entity.dart';
import 'category_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.imageUrl,
    super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final images = List<String>.from(json['images'] ?? const []);
    // This API sometimes returns images like '["https://..."]', so clean it.
    final image = images.isEmpty
        ? ''
        : images.first.replaceAll(RegExp(r'[\[\]"]'), '');

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      imageUrl: image,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }
}
