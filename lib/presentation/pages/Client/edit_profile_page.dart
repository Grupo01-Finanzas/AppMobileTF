import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/services/api/user_service.dart'; 

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _photoUrlController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userService = context.read<UserService>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userId = prefs.getInt('userId');

    if (accessToken != null && userId != null) {
      try {
        final userData = await userService.getUserByIdU(userId, accessToken);
        setState(() {
          _nameController.text = userData!.name ??'';
          _addressController.text = userData.address!;
          _phoneController.text = userData.phone!;
          _photoUrlController.text = userData.photoUrl!;
        });
      } catch (e) {
        print("Error loading user data: $e");
        // Handle error (e.g., show a SnackBar)
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final userService = context.read<UserService>();
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final userId = prefs.getInt('userId');

      if (accessToken != null && userId != null) {
        try {
          await userService.updateUser(
            userId: userId,
            name: _nameController.text,
            address: _addressController.text,
            phone: _phoneController.text,
            photoUrl: _photoUrlController.text,
            accessToken: accessToken,
          );

          // Optionally, update the user data in SharedPreferences 

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado exitosamente!')),
          );
        } catch (e) {
          print("Error updating profile: $e");
          // Handle error (e.g., show a SnackBar)
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
                      return 'Por favor, ingrese su nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  validator: (value) {
                    return value == null || value.isEmpty
                        ? 'Por favor, ingrese su dirección'
                        : null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (value) {
                    return value == null || value.isEmpty
                        ? 'Por favor, ingrese su teléfono'
                        : null;
                  },
                ),
                TextFormField(
                  controller: _photoUrlController,
                  decoration: const InputDecoration(labelText: 'URL de la foto'),

                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateProfile,
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