import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/product.dart';
import 'package:tf/services/api/product_service.dart';
import 'package:tf/services/api/establishment_service.dart';


class AdminProductsPage extends StatefulWidget {
  
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
  final productService = context.read<ProductService>();
  final establishmentService = context.read<EstablishmentService>();


  // Fetch the user and token from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  final accessToken = prefs.getString('accessToken');

  if (userId != null && accessToken != null) {

    final establishment = await establishmentService
        .getEstablishmentByAdminId(userId, accessToken);
    print('establishment: $establishment');
    if (establishment != null) {
      final establishmentId = establishment.id;
      print('establishmentId: $establishmentId');
      final products = await productService
          .getProductsByEstablishmentId(establishmentId, accessToken);
      print('products: $products');
      setState(() {
        _products = products;
      });
    }
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Productos'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _products.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return GestureDetector(
                  onTap: () {
                    context.go('/products/${product.id}/detail');
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          product.imageUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'S/ ${product.price}',
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add-product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}