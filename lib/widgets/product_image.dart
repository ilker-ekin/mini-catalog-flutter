import 'package:flutter/material.dart';

/// Product image from the network, with a local placeholder on error.
class ProductImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const ProductImage({super.key, required this.url, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
    );
  }
}
