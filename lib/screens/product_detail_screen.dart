import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_image.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final CartController cart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün detayı'),
        actions: [CartButton(cart: cart)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 300,
            child: ProductImage(url: product.image, radius: 16),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(product.tagline, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(
            product.price,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text('Açıklama', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(product.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text('Özellikler', style: theme.textTheme.titleMedium),
          Card(
            child: Column(
              children: [
                for (final spec in product.specs.entries)
                  ListTile(
                    dense: true,
                    title: Text(_capitalize(spec.key)),
                    trailing: Text(spec.value),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Sepete ekle'),
            onPressed: () {
              cart.add(product);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('${product.name} sepete eklendi')),
                );
            },
          ),
        ),
      ),
    );
  }

  static String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}
