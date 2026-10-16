import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  final VoidCallback onStartShopping;

  const EmptyCart({super.key, required this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 96,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text('Sepetiniz boş', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Beğendiğiniz ürünleri sepete ekleyerek alışverişe başlayın.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: onStartShopping,
              child: const Text('Alışverişe başla'),
            ),
          ],
        ),
      ),
    );
  }
}
