import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/user.dart';
import 'package:tf/services/api/user_service.dart';


class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userService = context.read<UserService>();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      final user = await userService.getUserByIdU(userId, accessToken);
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _currentUser != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(_currentUser!.photoUrl != null
                    ? _currentUser!.photoUrl!
                    : 'https://via.placeholder.com/150'),
                radius: 20,
              )
            : const CircularProgressIndicator(),
        title: _currentUser != null
            ? Text(
                 _currentUser!.name != null ? _currentUser!.name! : 'Usuario',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text('Cargando...'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildGridItem(
                      icon: Icons.history,
                      title: 'Historial de Transacciones',
                      onTap: () {
                        Navigator.pushNamed(context, '/clientTransactions');
                      },
                    ),
                    _buildGridItem(
                      icon: Icons.payment,
                      title: 'Mis Cuotas',
                      onTap: () {
                        Navigator.pushNamed(context, '/clientInstallments');
                      },
                    ),
                    _buildGridItem(
                      icon: Icons.account_balance_wallet,
                      title: 'Resumen de Cuenta',
                      onTap: () {
                        Navigator.pushNamed(context, '/clientAccountSummary');
                      },
                    ),
                    _buildGridItem(
                      icon: Icons.money,
                      title: 'Pagar Deuda',
                      onTap: () {
                        Navigator.pushNamed(context, '/clientPayDebt');
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0),
            const SizedBox(height: 16.0),
            Text(title, style: const TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}