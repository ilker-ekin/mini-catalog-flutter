import 'package:flutter/material.dart';

/// Rounded product image from the network, with a local placeholder on error.
class ProductImage extends StatelessWidget {
  final String url;
  final double radius;

  const ProductImage({super.key, required this.url, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
      ),
    );
  }
}
