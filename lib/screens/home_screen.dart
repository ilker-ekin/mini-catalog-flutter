import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';

/// Price range filters shown as chips (the data has no category field).
enum PriceFilter {
  all('Tümü'),
  under500('\$500 altı'),
  from500to1000('\$500 - \$1,000'),
  over1000('\$1,000 üstü');

  final String label;
  const PriceFilter(this.label);

  bool matches(double price) {
    switch (this) {
      case PriceFilter.all:
        return true;
      case PriceFilter.under500:
        return price < 500;
      case PriceFilter.from500to1000:
        return price >= 500 && price <= 1000;
      case PriceFilter.over1000:
        return price > 1000;
    }
  }
}

class HomeScreen extends StatefulWidget {
  final CartController cart;

  const HomeScreen({super.key, required this.cart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Product>> _productsFuture;
  String _query = '';
  PriceFilter _filter = PriceFilter.all;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.loadProducts();
  }

  List<Product> _applyFilters(List<Product> products) {
    final query = _query.trim().toLowerCase();
    return products
        .where((p) => p.name.toLowerCase().contains(query))
        .where((p) => _filter.matches(p.priceValue))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keşfet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('En yeni ürünleri bul', style: theme.textTheme.bodyMedium),
          ],
        ),
        centerTitle: false,
        toolbarHeight: 72,
        actions: [CartButton(cart: widget.cart)],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Ürünler yüklenemedi.'));
          }

          final products = _applyFilters(snapshot.data!);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Ürün ara',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final filter in PriceFilter.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter.label),
                          selected: _filter == filter,
                          onSelected: (_) => setState(() => _filter = filter),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const PromoBanner(),
              const SizedBox(height: 16),
              Text(
                'Ürünler (${products.length})',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (products.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('Aramanızla eşleşen ürün yok.')),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: product,
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
