import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/services/admin_service.dart';
 

class RegisterEstablishmentScreen extends StatefulWidget {
  const RegisterEstablishmentScreen({super.key});

  @override
  State<RegisterEstablishmentScreen> createState() =>
      _RegisterEstablishmentScreenState();
}

class _RegisterEstablishmentScreenState
    extends State<RegisterEstablishmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rucController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _rucController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Establishment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _rucController,
                  decoration: const InputDecoration(labelText: 'RUC'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the RUC';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the establishment name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _imageUrlController,
                  decoration:
                      const InputDecoration(labelText: 'Image URL (Optional)'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await context.read<AdminService>().registerEstablishment(
                                    _rucController.text,
                                    _nameController.text,
                                    _phoneController.text,
                                    _addressController.text,
                                    _imageUrlController.text,
                                  );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Establishment registered successfully!')),
                                );
                              // Redirige al Home del administrador
                              Navigator.of(context).pushReplacementNamed('/adminHome');
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to register: $e')),
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
                      : const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}