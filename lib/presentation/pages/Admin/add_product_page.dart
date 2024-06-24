import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/establishment.dart';
import 'package:tf/models/api/product.dart'; // Import your Product model
import 'package:tf/services/api/product_service.dart'; 

final List<String> productCategories = [
  'Grocery',
  'FruitAndVeg',
  'Meat',
  'Poultry',
  'Seafood',
  'Bakery',
  'Liquor',
  'GeneralStore',
];

class AddProductPage extends StatefulWidget {
  final Establishment establishment;
  const AddProductPage({super.key, required this.establishment});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
 final _stockController = TextEditingController();
String _selectedCategory = productCategories[0];


  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final productService = context.read<ProductService>();

      // Fetch access token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken != null) {
        try {
          final newProduct = Product(
            id: 0,
            name: _nameController.text,
            description: _descriptionController.text,
            price: double.parse(_priceController.text),
            imageUrl: _imageUrlController.text, 
            establishmentID: widget.establishment.id, 
            establishment: widget.establishment, 
            category: _selectedCategory, 
            stock: int.parse(_stockController.text), 
            isActive: true,
          );

          if (_imageUrlController.text.isEmpty) {
            newProduct.imageUrl = 'https://rahulindesign.websites.co.in/twenty-nineteen/img/defaults/product-default.png';
          }

          await productService.createProduct(
            name: newProduct.name,
            category: newProduct.category,
            description: newProduct.description,
            price: newProduct.price,
            stock: newProduct.stock,
            imageUrl: newProduct.imageUrl,
            isActive: newProduct.isActive,
            establishmentID: newProduct.establishmentID, 
            accessToken: accessToken
          );

          // Navigate back to the products list after successful creation
          context.pop(); 

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto agregado exitosamente!')),
          );
        } catch (e) {
          print("Error adding product: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar el producto: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                  maxLines: 3, // Allow multiple lines for description
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
                  decoration:
                      const InputDecoration(labelText: 'URL de la Imagen'),
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

                /// Category DropdownButton
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

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addProduct, 
                  child: const Text('Agregar Producto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}