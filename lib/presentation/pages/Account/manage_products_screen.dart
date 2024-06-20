import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/product.dart';
import 'package:tf/presentation/pages/Admin/add_product_screen.dart';

import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/product_service.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  late Future<List<Product>> _productsFuture;
  List<Product> _filteredProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productService = context.read<ProductService>();
    final authService = context.read<AuthenticationService>();
    final adminService = context.read<AdminService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        _productsFuture =
            productService.getProductsByEstablishmentId(establishmentId);
        _productsFuture.then((products) {
          setState(() {
            _filteredProducts = products;
          });
        });
      }
    }
  }

  void _filterProducts() {
    _productsFuture.then((products) {
      setState(() {
        _filteredProducts = products
            .where((product) => product.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Productos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _filterProducts();
              },
              decoration: const InputDecoration(
                hintText: 'Buscar producto por nombre...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return _buildProductTile(product);
                    },
                  );
                } else {
                  return const Center(
                      child: Text('No se encontraron productos'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddProductScreen(
              onProductAdded: () {
                
                _loadProducts();
                Navigator.of(context).pop();
              },
            ),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductTile(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            switch (action) {
              case 'edit':
                _editProduct(product);
                break;
              case 'delete':
                _deleteProduct(product);
                break;
              // Agregar más acciones aquí
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Editar'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Eliminar'),
            ),
            // Agregar más opciones aquí
          ],
        ),
      ),
    );
  }

  void _editProduct(Product product) {
    // Navega a la pantalla de edición de producto
    // Puedes pasar el objeto 'product' como argumento
    Navigator.of(context)
        .pushNamed('/editProduct', arguments: product);
  }

  void _deleteProduct(Product product) async {
    final productService = context.read<ProductService>();
    try {
      await productService.deleteProduct(product.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
      _loadProducts(); // Recarga la lista de productos
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el producto: $e')),
      );
    }
  }
}