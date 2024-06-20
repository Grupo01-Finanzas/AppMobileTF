import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/establishment.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/establishment_service.dart';

class EstablishmentSettingsScreen extends StatefulWidget {
  const EstablishmentSettingsScreen({super.key});

  @override
  State<EstablishmentSettingsScreen> createState() =>
      _EstablishmentSettingsScreenState();
}

class _EstablishmentSettingsScreenState
    extends State<EstablishmentSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rucController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isActive = false;
  bool _isLoading = false;
  late Future<Establishment> _establishmentFuture;

  @override
  void initState() {
    super.initState();
    _loadEstablishment();
  }

  Future<void> _loadEstablishment() async {
    final establishmentService = context.read<EstablishmentService>();
    final authService = context.read<AuthenticationService>();
    final adminService = context.read<AdminService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        _establishmentFuture =
            establishmentService.getEstablishmentById(establishmentId);
        _establishmentFuture.then((establishment) {
          setState(() {
            _rucController.text = establishment.ruc;
            _nameController.text = establishment.name;
            _phoneController.text = establishment.phone;
            _addressController.text = establishment.address;
            _imageUrlController.text = establishment.imageUrl;
            _isActive = establishment.isActive;
          });
        });
      }
    }
  }

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
      appBar: AppBar(title: const Text('Configuración del Establecimiento')),
      body: FutureBuilder<Establishment>(
        future: _establishmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // final establishment = snapshot.data!;
            return _buildSettingsForm();
          } else {
            return const Center(
                child: Text('No se encontró el establecimiento'));
          }
        },
      ),
    );
  }

  Widget _buildSettingsForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _rucController,
                decoration: const InputDecoration(labelText: 'RUC'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el RUC';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del establecimiento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el número de teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la dirección';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL de la Imagen'),
              ),
              const SizedBox(height: 16.0),
              SwitchListTile(
                title: const Text('Activo'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
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
                              await _updateEstablishment();
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Configuración guardada con éxito')),
                                );
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error al guardar la configuración: $e')),
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
                      : const Text('Guardar Cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateEstablishment() async {
    final establishmentService = context.read<EstablishmentService>();
    final authService = context.read<AuthenticationService>();
    final adminService = context.read<AdminService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        await establishmentService.updateEstablishment(
          establishmentId,
          _rucController.text,
          _nameController.text,
          _phoneController.text,
          _addressController.text,
          _isActive,
        );
      }
    }
  }
}