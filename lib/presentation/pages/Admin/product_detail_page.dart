import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/product.dart';
import 'package:tf/services/api/product_service.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? _product;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    final productService = context.read<ProductService>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      try {
        final product =
            await productService.getProductById(productId: widget.productId, accessToken: accessToken);
        setState(() {
          _product = Product.fromJson(product);
        });
      } catch (e) {
        print("Error fetching product details: $e");
        // Handle error, maybe show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener detalles del producto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_product!.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                _product!.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descripción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_product!.description),
            const SizedBox(height: 16),
            Text(
              'Precio: S/ ${_product!.price}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Stock: ${_product!.stock}',
              style: const TextStyle(fontSize: 18),
            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the edit product screen
          context.push('/products/${widget.productId}/edit'); // Define the '/products/:id/edit' route in your GoRouter
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}