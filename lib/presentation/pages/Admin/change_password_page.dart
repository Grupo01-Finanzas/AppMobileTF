import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/services/api/user_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final userService = context.read<UserService>();
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final userId = prefs.getInt('userId'); // Get the user ID

      if (accessToken != null && userId != null) {
        try {
          await userService.updatePassword(
            userId: userId, 
            newPassword: _newPasswordController.text,
            accessToken: accessToken,
          );

          // Optionally, update password in SharedPreferences or other secure storage if needed

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contraseña cambiada exitosamente!')),
          );

          context.pop(); // Navigate back after successful password change 
        } catch (e) {
          print("Error changing password: $e");
          // Handle error, maybe show a snackbar
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Contraseña'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Current Password
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña Actual'),
                validator: (value) {
                  return value!.isEmpty ? 'Ingrese su contraseña actual' : null;
                },
              ),

              // New Password
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nueva Contraseña'),
                validator: (value) {
                  return value!.isEmpty ? 'Ingrese su nueva contraseña' : null;
                },
              ),

              // Confirm New Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirmar Nueva Contraseña'),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('Cambiar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}