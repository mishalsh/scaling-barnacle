
import 'package:flutter/material.dart';
import 'package:larry_soft_app/screens/login_screen.dart';
import 'package:larry_soft_app/screens/products_screen.dart';
import 'package:larry_soft_app/screens/cart_screen.dart';
import 'package:larry_soft_app/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Larry Soft App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/products': (context) => const ProductsScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
