import 'package:flutter/material.dart';

import '../../../core/dummy_data.dart';
import 'home_models.dart';

extension ProductModelMapper on ProductModel {
  /// Converts an API product to the legacy [Product] used by the details screen.
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
