import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/api/establishment.dart';
import 'package:tf/presentation/widgets/admin/custom_text_form_field.dart';
import 'package:tf/services/api/establishment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEstablishmentPage extends StatefulWidget {
  final Establishment establishment;

  const EditEstablishmentPage({super.key, required this.establishment});

  @override
  State<EditEstablishmentPage> createState() => _EditEstablishmentPageState();
}

class _EditEstablishmentPageState extends State<EditEstablishmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _rucController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _isActiveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rucController.text = widget.establishment.ruc;
    _nameController.text = widget.establishment.name;
    _phoneController.text = widget.establishment.phone;
    _addressController.text = widget.establishment.address;
    _imageUrlController.text = widget.establishment.imageUrl;
    _isActiveController.text = widget.establishment.isActive ? 'true' : 'false';
  }

  @override
  void dispose() {
    _rucController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _imageUrlController.dispose();
    _isActiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Establecimiento'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  controller: _rucController,
                  hintText: 'RUC',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el RUC';
                    }
                    if (value.length != 11) {
                      return 'El RUC debe tener 11 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'Nombre',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: 'Teléfono',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el teléfono';
                    }
                    if (value.length != 9) {
                      return 'El teléfono debe tener 9 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _addressController,
                  hintText: 'Dirección',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la dirección';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _imageUrlController,
                  hintText: 'URL de la imagen',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la URL de la imagen';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _isActiveController,
                  hintText: 'Activo (true/false)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese si está activo o no';
                    }
                    if (value != 'true' && value != 'false') {
                      return 'Valor no válido. Ingrese "true" o "false"';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final establishmentService =
                          context.read<EstablishmentService>();
                      final prefs = await SharedPreferences.getInstance();
                      final accessToken = prefs.getString('accessToken');
                      if (accessToken != null) {
                        final updatedEstablishment = Establishment(
                          id: widget.establishment.id,
                          ruc: _rucController.text,
                          name: _nameController.text,
                          phone: _phoneController.text,
                          address: _addressController.text,
                          imageUrl: _imageUrlController.text,
                          isActive: _isActiveController.text == 'true',
                          admin: widget.establishment.admin,
                          lateFeePercentage: widget.establishment.lateFeePercentage,
                        );
                        try {
                          await establishmentService.updateEstablishmentU(
                              widget.establishment.id, updatedEstablishment, accessToken);
                          // Update successful
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Establecimiento actualizado')),
                          );
                          Navigator.of(context).pop();
                                                } catch (e) {
                          // Handle errors
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Actualizar'),
                ),
              ],
            ),
          ),
      ),
    ));
  }
}