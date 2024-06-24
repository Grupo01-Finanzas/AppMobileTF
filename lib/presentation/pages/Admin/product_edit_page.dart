import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/establishment.dart';
import 'package:tf/models/api/product.dart';
import 'package:tf/presentation/pages/Admin/add_product_page.dart';
import 'package:tf/services/api/establishment_service.dart';
import 'package:tf/services/api/product_service.dart';


class ProductEditPage extends StatefulWidget {
  final int productId;

  const ProductEditPage({super.key, required this.productId});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _stockController = TextEditingController();
  String _selectedCategory = productCategories[0];
  bool _isActive = true; // Add isActive controller

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
        final productData = await productService.getProductById(
            productId: widget.productId, accessToken: accessToken);
        final product = Product.fromJson(productData);

        setState(() {
          _nameController.text = product.name;
          _descriptionController.text = product.description;
          _priceController.text = product.price.toString();
          _imageUrlController.text = product.imageUrl;
          _stockController.text = product.stock.toString();
          _selectedCategory = product.category;
          _isActive = product.isActive; // Initialize isActive
        });
      } catch (e) {
        print("Error fetching product details: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al obtener detalles del producto')),
        );
      }
    }
  }

  // Define _fetchEstablishmentData helper function
  Future<Establishment?> _fetchEstablishmentData(String? accessToken) async {
    if (accessToken == null) {
      return null;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) {
        return null;
      }
      return await EstablishmentService()
          .getEstablishmentByAdminId(userId, accessToken);
    } catch (e) {
      print("Error fetching establishment data: $e");
      return null;
    }
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final productService = context.read<ProductService>();

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      final establishment = await _fetchEstablishmentData(accessToken);

      if (accessToken != null && establishment != null) {
        try {
          // Create updated product object
          final updatedProduct = Product(
            id: widget.productId, // Important: Include the product ID
            name: _nameController.text,
            description: _descriptionController.text,
            price: double.parse(_priceController.text),
            imageUrl: _imageUrlController.text,
            stock: int.parse(_stockController.text),
            category: _selectedCategory,
            isActive: _isActive, // Include isActive in the update
            establishmentID: establishment.id, // You might need to adjust how you get this
            establishment: establishment, // Assuming you don't need to update this
          );

          await productService.updateProduct(
            productId: updatedProduct.id,
            name: updatedProduct.name,
            category: updatedProduct.category,
            description: updatedProduct.description,
            price: updatedProduct.price,
            stock: updatedProduct.stock,
            imageUrl: updatedProduct.imageUrl,
            isActive: updatedProduct.isActive,
            accessToken: accessToken,
          );

          // Navigate back after updating
          context.pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto actualizado exitosamente!')),
          );
        } catch (e) {
          print("Error updating product: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Error al actualizar el producto: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el nombre del producto';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese una descripción';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el precio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, ingrese un precio válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese la URL de la imagen';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el stock';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor, ingrese un stock válido';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: productCategories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, seleccione una categoría';
                    }
                    return null;
                  },
                ),
                // Is Active Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value!;
                        });
                      },
                    ),
                    const Text('Activo'),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateProduct,
                  child: const Text('Actualizar Producto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}