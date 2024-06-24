import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/establishment.dart';
import 'package:tf/models/api/user.dart';
import 'package:tf/repository/establishment_repository.dart';
import 'package:tf/services/api/user_service.dart';

class EstablishmentSettingsPage extends StatefulWidget {
  const EstablishmentSettingsPage({super.key});

  @override
  State<EstablishmentSettingsPage> createState() =>
      _EstablishmentSettingsPageState();
}

class _EstablishmentSettingsPageState
    extends State<EstablishmentSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _rucController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _lateFeePercentageController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _loadEstablishmentData();
  }

  Future<void> _loadEstablishmentData() async {
    final establishmentRepository = context.read<EstablishmentRepository>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      try {
        final establishment =
            await establishmentRepository.getEstablishment(accessToken);
        if (establishment != null) {
          setState(() {
            _rucController.text = establishment.ruc;
            _nameController.text = establishment.name;
            _phoneController.text = establishment.phone;
            _addressController.text = establishment.address;
            _imageUrlController.text = establishment.imageUrl;
            _lateFeePercentageController.text =
                establishment.lateFeePercentage.toString();
            _isActive = establishment.isActive;
          });
        }
      } catch (e) {
        print("Error loading establishment data: $e");
        // Handle error (e.g., show a SnackBar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _updateEstablishment() async {
    if (_formKey.currentState!.validate()) {
      final establishmentRepository = context.read<EstablishmentRepository>();
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final establishmentId = prefs.getInt('establishmentId');

      final userService = context.read<UserService>();
      final currentUser = await userService.getCurrentUser(accessToken: accessToken ?? '');

      if (accessToken != null && establishmentId != null) {
        try {
          final updatedEstablishment = Establishment(
            id: establishmentId,
            ruc: _rucController.text,
            name: _nameController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            imageUrl: _imageUrlController.text,
            lateFeePercentage:
                int.parse(_lateFeePercentageController.text), // Parse as double
            isActive: _isActive,
            admin: User.fromJson(currentUser),
          );

          await establishmentRepository.updateEstablishment(
              establishmentId, updatedEstablishment, accessToken);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Configuración del establecimiento actualizada!')),
          );
        } catch (e) {
          print("Error updating establishment: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración del Establecimiento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RUC
                TextFormField(
                  controller: _rucController,
                  decoration: const InputDecoration(labelText: 'RUC'),
                  enabled: false, // Prevent editing of RUC
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el RUC';
                    }
                    return null;
                  },
                ),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del establecimiento';
                    }
                    return null;
                  },
                ),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el teléfono del establecimiento';
                    }
                    return null;
                  },
                ),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la dirección del establecimiento';
                    }
                    return null;
                  },
                ),

                // Image URL
                TextFormField(
                  controller: _imageUrlController,
                  decoration:
                      const InputDecoration(labelText: 'URL de la Imagen'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la URL de la imagen';
                    }
                    
                    return null;
                  },
                ),

                // Late Fee Percentage
                TextFormField(
                  controller: _lateFeePercentageController,
                  decoration: const InputDecoration(
                      labelText: 'Porcentaje de Cargo por Mora (%)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el porcentaje';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un valor numérico válido';
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

                const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: _updateEstablishment,
                  child: const Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}