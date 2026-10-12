class CategoryModel {
  final int id;
  final String name;
  final String image;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '',
      );
}

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final CategoryModel? category;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.category,
  });

  /// First image, cleaned (this API sometimes returns images like '["https://..."]').
  String get imageUrl {
    if (images.isEmpty) return '';
    return images.first.replaceAll(RegExp(r'[\[\]"]'), '');
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        description: json['description'] ?? '',
        images: List<String>.from(json['images'] ?? const []),
        category: json['category'] != null
            ? CategoryModel.fromJson(json['category'])
            : null,
      );
}
