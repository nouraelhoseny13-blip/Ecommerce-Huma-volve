import 'package:flutter/material.dart';

import '../../../../core/dummy_data.dart';
import '../../domain/entities/product_entity.dart';

extension ProductEntityMapper on ProductEntity {
  /// Converts a domain product to the legacy [Product] used by the details screen.
  Product toLegacyProduct() => Product(
        id: id.toString(),
        name: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        colors: const [Colors.black, Colors.white, Colors.grey],
        sizes: const ['S', 'M', 'L', 'XL'],
      );
}
