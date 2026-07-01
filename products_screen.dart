
import 'package:flutter/material.dart';
import 'package:larry_soft_app/database/database_helper.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await DatabaseHelper.instance.getProducts();
    setState(() {
      _products = products;
    });
  }

  void _addToCart(Map<String, dynamic> product) async {
    await DatabaseHelper.instance.addProductToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Placeholder for image. In a real app, this would load from a URL or asset.
                        Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: Center(
                            child: Text(
                              product['imageUrl'] ?? 'No Image',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          product['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(product['description']),
                        const SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${product['price'].toStringAsFixed(2)} SAR',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _addToCart(product),
                          child: const Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
