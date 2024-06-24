import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/services/api/admin_service.dart'; 
import 'package:tf/services/api/user_service.dart';

class EditAdminProfilePage extends StatefulWidget {
  const EditAdminProfilePage({super.key});

  @override
  State<EditAdminProfilePage> createState() => _EditAdminProfilePageState();
}

class _EditAdminProfilePageState extends State<EditAdminProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _photoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAdminData(); 
  }

  Future<void> _loadAdminData() async {
    final userService = context.read<UserService>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userId = prefs.getInt('userId'); 

    if (accessToken != null && userId != null) {
      try {
        final adminData = await userService.getUserByIdU(userId, accessToken); // Assuming your admin details are fetched using UserService
        setState(() {
          _nameController.text = adminData!.name!;
          _addressController.text = adminData.address!;
          _phoneController.text = adminData.phone!;
          _photoUrlController.text = adminData.photoUrl!;
        });
      } catch (e) {
        print("Error loading admin data: $e");
        // Handle error, maybe show a snackbar
      }
    }
  }

  Future<void> _updateAdminProfile() async {
    if (_formKey.currentState!.validate()) {
      final adminService = context.read<AdminService>();
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken != null) {
        try {
          await adminService.updateAdminProfile(
            name: _nameController.text,
            address: _addressController.text,
            phone: _phoneController.text,
            photoUrl: _photoUrlController.text,
            accessToken: accessToken,
          );
          // Optionally, update the admin data in SharedPreferences
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil de administrador actualizado!')),
          );
        } catch (e) {
          print("Error updating admin profile: $e");
          // Handle error, maybe show a snackbar
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  return value!.isEmpty ? 'Por favor ingrese un nombre' : null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  return value!.isEmpty ? 'Por favor ingrese una dirección' : null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  return value!.isEmpty ? 'Por favor ingrese un teléfono' : null;
                },
              ),
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(labelText: 'URL de la foto'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateAdminProfile, 
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}