import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../screens/cart_screen.dart';

/// Cart icon with item count badge. Opens the cart with Navigator.push.
class CartButton extends StatelessWidget {
  final CartController cart;

  const CartButton({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        return IconButton(
          tooltip: 'Sepet',
          icon: Badge(
            isLabelVisible: cart.itemCount > 0,
            label: Text('${cart.itemCount}'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen(cart: cart)),
            );
          },
        );
      },
    );
  }
}
