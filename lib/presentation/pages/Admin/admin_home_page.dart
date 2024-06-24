import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tf/models/api/credit_account.dart';
import 'package:tf/models/api/user.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/services/api/credit_account_service.dart';
import 'package:tf/services/api/user_service.dart';

class AdminHomePage extends StatefulWidget {
  final int establishmentId;
  const AdminHomePage({super.key, required this.establishmentId});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  User? _currentUser; 
  CreditAccount? _creditAccount;

  @override
  void initState() {
    super.initState();
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
        final user =
            await userService.getUserByIdU(userId, accessToken);
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
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _buildGridItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Administrar Transactions',
                  onTap: () {
                    context.go('/manageTransactions');
                  },
                ),
                _buildGridItem(
                  icon: Icons.people,
                  title: 'Administrar Clientes',
                  onTap: () {
                    context.go('/establishments/${widget.establishmentId}/manageClients');
                  },
                ),
                _buildGridItem(
                  icon: Icons.shopping_cart,
                  title: 'Configurar Tasa de Interés',
                  onTap: () {
                   context.go('/interestRateSettings', extra: _creditAccount);
                  },
                ),
                _buildGridItem(
                  icon: Icons.settings,
                  title: 'Configuración del Establecimiento',
                  onTap: () {
                    context.go('/establishmentSettings');
                  },
                ),
              ],
            ),
          ),
        ],
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