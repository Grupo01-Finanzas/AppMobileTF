import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/product.dart';
import 'package:tf/models/product_category.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/establishment_service.dart';
import 'package:tf/services/product_service.dart';



class AddProductScreen extends StatefulWidget {
  final VoidCallback onProductAdded;

  const AddProductScreen({super.key, required this.onProductAdded});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  ProductCategory? _selectedCategory;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una descripción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un precio';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Ingresa un precio válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<ProductCategory>(
                  value: _selectedCategory,
                  onChanged: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  items: ProductCategory.values
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona una categoría';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un stock';
                    }
                    final stock = int.tryParse(value);
                    if (stock == null || stock < 0) {
                      return 'Ingresa un stock válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una URL de imagen';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                await _addProduct();
                                widget.onProductAdded(); // Llama al callback
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Producto agregado con éxito')),
                                  );
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Error al agregar el producto: $e')),
                                  );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Agregar Producto'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addProduct() async {
    final productService = context.read<ProductService>();
    final authService = context.read<AuthenticationService>();
    final adminService = context.read<AdminService>();
    final establishmentService = context.read<EstablishmentService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        final establishment = await establishmentService.getEstablishmentById(establishmentId);

        final newProduct = Product(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          category: _selectedCategory!.name, // Usa el nombre del enum
          stock: int.parse(_stockController.text),
          imageUrl: _imageUrlController.text,
          isActive: true,
          id: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          establishment: establishment,
        );

        await productService.createProduct(
          newProduct.name,
          newProduct.description,
          newProduct.price,
          newProduct.category,
          newProduct.stock,
          newProduct.imageUrl,
          newProduct.isActive,
          newProduct.establishment!.id,
        );
      }
    }
  }
}