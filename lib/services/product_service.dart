import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

/// Reads the product list from a local JSON file (API simulation).
class ProductService {
  static const String _path = 'assets/data/products.json';

  static Future<List<Product>> loadProducts() async {
    final raw = await rootBundle.loadString(_path);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final items = json['data'] as List<dynamic>;
    return items
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
