import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';


class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose your role:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () => _navigateToClientHome(context),
              child: const Text('Client'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navigateToAdminFlow(context),
              child: const Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToClientHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/clientHome');
  }

   Future<void> _navigateToAdminFlow(BuildContext context) async {
    final authService = context.read<AuthenticationService>();
    final adminService = context.read<AdminService>();

    try {
      final user = await authService.getCurrentUser();
      if (user == null) {
        // Manejar el caso en el que el usuario no esté encontrado
        print("User not found");
        return;
      }

      if (user.rol == 'USER') {
        // El usuario aún no tiene un rol definido, muéstrale la pantalla de selección de rol
        Navigator.of(context).pushReplacementNamed('/roleSelection');
      } else if (user.rol == 'CLIENT') {
        // Redirige al usuario al Home del cliente
        Navigator.of(context).pushReplacementNamed('/clientHome');
      } else if (user.rol == 'ADMIN') {
        // El usuario es un administrador, verifica si tiene establecimientos
        final establishments =
            await adminService.getEstablishmentsByAdminId(user.id);
        if (establishments.isEmpty) {
          // No tiene establecimientos, redirige a la vista de registro de establecimiento
          Navigator.of(context).pushReplacementNamed('/registerEstablishment');
        } else if (establishments.length == 1) {
          // Tiene un solo establecimiento, redirige al Home del administrador para ese establecimiento
          Navigator.of(context)
              .pushReplacementNamed('/adminHome', arguments: establishments[0].id);
        } else {
          // Tiene varios establecimientos, muéstrale una pantalla para que elija uno
          Navigator.of(context).pushReplacementNamed('/establishmentSelection',
              arguments: establishments);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
    }
  }
}