import '../../domain/entities/product_entity.dart';
import 'category_model.dart';

class ProductModel extends ProductEntity {
  static const String _fallbackImage =
      'https://placehold.co/600x600/png?text=Product';

  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.imageUrl,
    super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImages = (json['images'] as List? ?? const [])
        .map((e) => e.toString())
        .toList();
    final validImages = _extractValidImageUrls(rawImages);

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      imageUrl: validImages.isNotEmpty ? validImages.first : _fallbackImage,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }

  static List<String> _extractValidImageUrls(List<String> rawImages) {
    final validUrls = <String>[];
    final urlRegex = RegExp(r'https?://[^\s"\[\]\\]+');

    for (final raw in rawImages) {
      final str = raw.trim();
      if (str.isEmpty) continue;

      for (final match in urlRegex.allMatches(str)) {
        final url = match.group(0)!.replaceAll(RegExp(r'[,.]+$'), '').trim();
        if (_isValidImageUrl(url)) {
          validUrls.add(url);
        }
      }
    }

    return validUrls;
  }

  static bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    return uri.host.isNotEmpty;
  }
}