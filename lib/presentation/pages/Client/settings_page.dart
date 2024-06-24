import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSettingItem(
            icon: Icons.person,
            title: 'Mi Perfil',
            onTap: () {
              // Navigate to the EditProfilePage
              Navigator.pushNamed(context, '/editProfile');
            },
          ),
          _buildSettingItem(
            icon: Icons.lock,
            title: 'Cambiar Contraseña',
            onTap: () {
              // Navigate to the ChangePasswordPage
              Navigator.pushNamed(context, '/changePassword');
            },
          ),
          _buildSettingItem(
            icon: Icons.exit_to_app,
            title: 'Cerrar Sesión',
            onTap: () {
              // Log out the user
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}