import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/controllers/cart_controller.dart';
import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/product.dart';

void main() {
  // Each widget test runs in its own fake-async zone; don't reuse cached assets.
  setUp(() => rootBundle.clear());

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
    await _pumpApp(tester, CartController());

    expect(find.text('Keşfet'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'airpods');
    await tester.pumpAndSettle();

    expect(find.text('iPhone 15 Pro'), findsNothing);
    expect(find.text('AirPods Max'), findsOneWidget);
  });

  testWidgets('Detail -> add to cart -> cart -> remove / checkout', (
    tester,
  ) async {
    final cart = CartController();
    await _pumpApp(tester, cart);

    // Open detail via named route and add the product twice.
    await tester.tap(find.text('iPhone 15 Pro'));
    await tester.pumpAndSettle();
    expect(find.text('Ürün detayı'), findsOneWidget);
    await tester.tap(find.text('Sepete ekle'));
    await tester.tap(find.text('Sepete ekle'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget); // badge count

    // Open cart, remove item -> empty state.
    await tester.tap(find.byTooltip('Sepet'));
    await tester.pumpAndSettle();
    expect(find.text('Sepetim'), findsOneWidget);
    expect(find.text(r'$1,998'), findsNWidgets(2)); // line total + cart total
    await tester.tap(find.byTooltip('Kaldır'));
    await tester.pumpAndSettle();
    expect(find.text('Sepetiniz boş'), findsOneWidget);

    // Checkout clears the cart.
    cart.add(Product.fromJson({'id': 99, 'name': 'Test', 'price': r'$10'}));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Siparişi tamamla'));
    await tester.pump();
    expect(find.text('Siparişiniz alındı (simülasyon)'), findsOneWidget);
    expect(cart.isEmpty, isTrue);
  });
}

/// Pumps the app and waits (in real time) until products are loaded from JSON.
Future<void> _pumpApp(WidgetTester tester, CartController cart) async {
  // Phone-sized screen so the first products are visible.
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MiniKatalogApp(cart: cart));
  for (var i = 0; i < 50 && find.byType(GridView).evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}
