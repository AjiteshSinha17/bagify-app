import 'package:flutter/material.dart';
import 'package:bagify_app/data/product_data.dart'; // Import product data
import 'package:bagify_app/data/cart_dart.dart'; // Import cart data
import 'package:bagify_app/screens/cart.dart'; // Import CartScreen widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Set to keep track of selected brands for filtering
  Set<String> selectedBrands = {};

  // Extract unique brands from products
  late final List<String> brands = products
      .map<String>((product) => product["brand"] as String)
      .toSet()
      .toList();

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Filter by Brand"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: brands.map((brand) {
              return CheckboxListTile(
                title: Text(brand),
                value: selectedBrands.contains(brand),
                onChanged: (bool? checked) {
                  setState(() {
                    checked!
                        ? selectedBrands.add(brand)
                        : selectedBrands.remove(brand);
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bagify - Home"), actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () => _showFilterDialog(),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => Navigator.pushNamed(context, "/cart"),
        ),
      ]),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product["description"]),
                    Row(
                      children: List.generate(
                          product["rating"].round(),
                          (_) =>
                              Icon(Icons.star, color: Colors.orange, size: 16)),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _navigateToCart(product["name"]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToCart(String productName) {
    addToCart(productName);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartScreen(productName: productName)),
    );
  }
}
