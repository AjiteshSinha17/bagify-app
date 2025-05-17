import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final String productName;

  const CartScreen({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Center(
        child:
            Text("$productName added to cart!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
