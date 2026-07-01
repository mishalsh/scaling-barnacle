
import 'package:flutter/material.dart';
import 'package:larry_soft_app/database/database_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final items = await DatabaseHelper.instance.getCartItems();
    double total = 0.0;
    for (var item in items) {
      total += item['price'] * item['quantity'];
    }
    setState(() {
      _cartItems = items;
      _totalPrice = total;
    });
  }

  void _removeProductFromCart(int id) async {
    await DatabaseHelper.instance.removeProductFromCart(id);
    _loadCartItems(); // Reload cart items after removal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item removed from cart')),
    );
  }

  void _checkout() {
    // In a real app, this would involve payment processing and order finalization.
    // For this example, we'll just clear the cart.
    DatabaseHelper.instance.clearCart();
    _loadCartItems();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checkout successful! Cart cleared.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: _cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_basket),
                          title: Text(item['name']),
                          subtitle: Text('${item['quantity']} x ${item['price'].toStringAsFixed(2)} SAR'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_shopping_cart),
                            onPressed: () => _removeProductFromCart(item['id']),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: ${_totalPrice.toStringAsFixed(2)} SAR',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _checkout,
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
