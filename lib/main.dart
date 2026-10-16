import 'package:flutter/material.dart';

import 'controllers/cart_controller.dart';
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';

void main() {
  runApp(MiniKatalogApp(cart: CartController()));
}

class MiniKatalogApp extends StatelessWidget {
  final CartController cart;

  const MiniKatalogApp({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(cart: cart),
              settings: settings,
            );
          case '/detail':
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product, cart: cart),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
