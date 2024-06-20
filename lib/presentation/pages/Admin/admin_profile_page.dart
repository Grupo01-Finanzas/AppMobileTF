import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/admin.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;
  late Future<Admin> _adminFuture;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    final authService = context.read<AuthenticationService>();
    final adminService = context.read<AdminService>();
    final user = await authService.getCurrentUser();
    if (user != null) {
      _adminFuture = adminService.getAdmin(user.id) as Future<Admin>;
      _adminFuture.then((admin) {
        setState(() {
          _nameController.text = admin.user!.name;
          _emailController.text = admin.user!.email;
          _phoneController.text = admin.user!.phone;
          _addressController.text = admin.user!.address;
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Administrador')),
      body: FutureBuilder<Admin>(
        future: _adminFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final admin = snapshot.data!;
            return _buildProfileForm(admin);
          } else {
            return const Center(child: Text('Administrador no encontrado'));
          }
        },
      ),
    );
  }

  Widget _buildProfileForm(Admin admin) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(admin.user!.photoUrl),
              ),
              const SizedBox(height: 16.0),
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un correo';
                  }
                  if (!value.contains('@')) {
                    return 'Ingresa un correo válido';
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
                    return 'Ingresa un teléfono';
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
                    return 'Ingresa una dirección';
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
                              await _updateAdmin(admin);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Perfil actualizado con éxito')),
                                );
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error al actualizar el perfil: $e')),
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

  Future<void> _updateAdmin(Admin admin) async {
    final adminService = context.read<AdminService>();
    final authService = context.read<AuthenticationService>();
    final user = await authService.getCurrentUser();
    if (user != null) {
      /*final updatedUser = User(
        id: user.id,
        dni: user.dni,
        email: _emailController.text,
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        photoUrl: user.photoUrl,
        rol: user.rol,
        createdAt: user.createdAt,
        updatedAt: DateTime.now(),
      );*/
      await adminService.updateAdmin(
        admin.id,
        true
      );
    }
  }
}