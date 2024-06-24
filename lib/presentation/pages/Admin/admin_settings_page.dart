import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/credit_account.dart';
import 'package:tf/models/api/establishment.dart';
import 'package:tf/models/api/user.dart';
import 'package:tf/presentation/pages/Admin/edit_establishment_page.dart';
import 'package:tf/services/api/credit_account_service.dart';
import 'package:tf/services/api/establishment_service.dart';
import 'package:tf/services/api/user_service.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  Establishment? _establishment;
  bool _isLoading = true;
  User? _currentUser;
  CreditAccount? _creditAccount;

  @override
  void initState() {
    super.initState();
    _loadEstablishmentData();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userService = context.read<UserService>();
    final creditAccountService = context.read<CreditAccountService>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userId = prefs.getInt('userId');

    if (accessToken != null && userId != null) {
      try {
        final user = await userService.getUserByIdU(userId, accessToken);
        setState(() {
          _currentUser = user;
        });

        // Fetch credit account after getting the user
        if (_currentUser != null) {
          final creditAccount = await creditAccountService
              .getCreditAccountByClientId(_currentUser!.id!, accessToken);
          setState(() {
            _creditAccount = creditAccount;
          });
        }
      } catch (e) {
        print("Error fetching user or credit account data: $e");
      }
    }
  }

  // Logout method
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear all data from SharedPreferences
    await prefs.clear(); 

    // Navigate to the login page
    context.go('/login');
  }

  Future<void> _loadEstablishmentData() async {
    final establishmentService = context.read<EstablishmentService>();
    final userService = context.read<UserService>();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      final user = await userService.getUserById(
          userId: userId, accessToken: accessToken);
      final userIdU = user['id'];
      final establishment = await establishmentService
          .getEstablishmentByAdminId(userIdU, accessToken);
      setState(() {
        _establishment = establishment;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                _buildSettingItem(
                  icon: Icons.business,
                  title: 'Información del Establecimiento',
                  onTap: () {
                    // Navigate to a screen to edit establishment details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEstablishmentPage(
                            establishment: _establishment!), // Pass data
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  icon: Icons.money,
                  title: 'Configurar Tasa de Interés',
                  onTap: () {
                    context.go('/interestRateSettings', extra: _creditAccount);
                  },
                ),
                _buildSettingItem(
                  icon: Icons.person,
                  title: 'Editar Mi Perfil',
                  onTap: () {
                    // Navigate to a screen to edit admin profile
                    context.go('/editAdminProfile');
                  },
                ),
                _buildSettingItem(
                  icon: Icons.lock,
                  title: 'Cambiar Contraseña',
                  onTap: () {
                    // Navigate to a screen to change password
                    context.go('/changePassword');
                  },
                ),
                _buildSettingItem(
                  icon: Icons.exit_to_app,
                  title: 'Cerrar Sesión',
                  onTap: () {
                    // Log out the user
                    _logout();
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
