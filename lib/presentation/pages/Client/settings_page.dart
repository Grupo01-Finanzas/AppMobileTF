import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/user.dart';
import 'package:tf/services/authentication_service.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: FutureBuilder<User?>(
        future: context.read<AuthenticationService>().getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return _buildSettingsContent(user, context);
          } else {
            return const Center(child: Text('Usuario no encontrado'));
          }
        },
      ),
    );
  }

  Widget _buildSettingsContent(User user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(user.photoUrl),
          ),
          const SizedBox(height: 16.0),
          Text(
            user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            user.email,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32.0),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
          // Agrega más opciones de configuración aquí
        ],
      ),
    );
  }
}