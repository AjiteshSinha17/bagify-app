import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:bagify_app/data/product_data.dart';
import 'package:bagify_app/screens/cart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<String> selectedBrands = {};

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
      appBar: AppBar(
        title: Text("Bagify - Home"),
        actions: [
          IconButton(
              icon: Icon(Icons.filter_list), onPressed: _showFilterDialog),
          SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => _navigateToCart(context, "")),
          SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.pushNamed(context, "/search")),
          SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => Navigator.pushNamed(context, "/sign-in")),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: products
                .where((product) =>
                    selectedBrands.isEmpty ||
                    selectedBrands.contains(product["brand"]))
                .length,
            itemBuilder: (context, index) {
              final filteredProducts = products
                  .where((product) =>
                      selectedBrands.isEmpty ||
                      selectedBrands.contains(product["brand"]))
                  .toList();
              final product = filteredProducts[index];

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: FutureBuilder(
                    future:
                        precacheImage(NetworkImage(product["image"]), context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: product["image"],
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error, color: Colors.red),
                        );
                      }
                      return SizedBox(
                        width: 56,
                        height: 56,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                  title: Text(product["name"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product["description"]),
                      Row(
                        children: List.generate(
                          product["rating"].round(),
                          (_) =>
                              Icon(Icons.star, color: Colors.orange, size: 16),
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _navigateToCart(context, product["name"]),
                  ),
                ),
              );
            },
          )),
    );
  }

  void _navigateToCart(BuildContext context, String productName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartScreen(productName: productName)),
    );
  }
}
