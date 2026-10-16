import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/controllers/cart_controller.dart';
import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/product.dart';

void main() {
  final json = <String, dynamic>{
    'id': 6,
    'name': 'MacBook Pro 16"',
    'tagline': 'Mind-blowing. Head-turning.',
    'description': 'Test description',
    'price': r'$2,499',
    'currency': 'USD',
    'image': 'https://wantapi.com/assets/images/macbook.png',
    'specs': {'chip': 'M3 Max', 'display': 'Liquid Retina XDR'},
  };

  test('Product.fromJson / toJson round trip', () {
    final product = Product.fromJson(json);

    expect(product.name, 'MacBook Pro 16"');
    expect(product.priceValue, 2499);
    expect(product.specs['chip'], 'M3 Max');
    expect(product.toJson(), json);
  });

  test('formatPrice uses the data format', () {
    expect(formatPrice(2598), r'$2,598');
    expect(formatPrice(99), r'$99');
  });

  test('CartController add / remove / total', () {
    final cart = CartController();
    final product = Product.fromJson(json);

    cart.add(product);
    cart.add(product);
    expect(cart.itemCount, 2);
    expect(cart.totalPrice, 4998);

    cart.remove(product);
    expect(cart.isEmpty, isTrue);
  });

  testWidgets('Home screen shows products from JSON', (tester) async {
    await tester.pumpWidget(MiniKatalogApp(cart: CartController()));
    await tester.pumpAndSettle();

    expect(find.text('Keşfet'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'airpods');
    await tester.pumpAndSettle();

    expect(find.text('iPhone 15 Pro'), findsNothing);
    expect(find.text('AirPods Max'), findsOneWidget);
  });
}
