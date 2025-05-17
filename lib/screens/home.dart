import 'package:flutter/material.dart';
import 'package:bagify_app/screens/cart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> brands = [
    "Nike",
    "Adidas",
    "Puma",
    "Reebok",
    "New Balance"
  ];
  String selectedBrand = "Nike"; // Default selected brand

  final List<Map<String, dynamic>> products = [
    {"name": "Nike Shoes", "brand": "Nike"},
    {"name": "Adidas Sneakers", "brand": "Adidas"},
    {"name": "Puma Sportswear", "brand": "Puma"},
  ];

  void _filterByBrand(String brand) {
    setState(() {
      selectedBrand = brand;
    });
  }

  void _navigateToCart(String productName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartScreen(productName: productName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bagify - Home"),
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push( 
              context,
              MaterialPageRoute(builder: (context) => CartScreen(productName: "")),
            );
          },
        ),
      ],
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedBrand,
            items: brands.map((brand) {
              return DropdownMenuItem(
                value: brand,
                child: Text(brand),
              );
            }).toList(),
            onChanged: (newBrand) {
              if (newBrand != null) _filterByBrand(newBrand);
            },
          ),
          Expanded(
            child: ListView(
              children: products
                  .where((p) => p["brand"] == selectedBrand)
                  .map((product) {
                return ListTile(
                  title: Text(product["name"]),
                  trailing: ElevatedButton(
                    onPressed: () => _navigateToCart(product["name"]),
                    child: Text("Add to Cart"),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
