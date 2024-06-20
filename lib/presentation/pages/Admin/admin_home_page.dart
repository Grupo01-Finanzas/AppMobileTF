import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/credit_request.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/client_service.dart';
import 'package:tf/services/credit_request_service.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _pendingCreditRequestCount = 0;
  List<CreditRequest> _pendingCreditRequests = [];

  @override
  void initState() {
    super.initState();
    _loadPendingCreditRequests();
  }

  Future<void> _loadPendingCreditRequests() async {
    final creditRequestService = context.read<CreditRequestService>();
    final adminService = context.read<AdminService>();
    final authService = context.read<AuthenticationService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        final pendingRequests = await creditRequestService
            .getPendingCreditRequestsByEstablishmentId(establishmentId);
        setState(() {
          _pendingCreditRequests = pendingRequests;
          _pendingCreditRequestCount = pendingRequests.length;
        });
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () async {
              final clientService = context.read<ClientService>();
              for (var request in _pendingCreditRequests) {
                final client = await clientService.getClientById(request.clientId);
                final clientName = client.user?.name ?? 'Unknown';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Solicitud de crédito de $clientName por ${request.requestedCreditLimit} soles',
                    ),
                  ),
                );
              }
            },
            child: Row(
              children: [
                const Icon(Icons.notifications, color: Colors.orange),
                const SizedBox(width: 8.0),
                Text(
                  'Solicitudes de crédito pendientes: $_pendingCreditRequestCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16.0),
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: [
              _buildGridItem(
                icon: Icons.account_balance_wallet,
                title: 'Administrar Cuentas de Crédito',
                onTap: () {
                  Navigator.of(context).pushNamed('/manageCreditAccounts');
                },
              ),
              _buildGridItem(
                icon: Icons.people,
                title: 'Administrar Clientes',
                onTap: () {
                  Navigator.of(context).pushNamed('/manageClients');
                },
              ),
              _buildGridItem(
                icon: Icons.shopping_cart,
                title: 'Administrar Productos',
                onTap: () {
                  Navigator.of(context).pushNamed('/manageProducts');
                },
              ),
              _buildGridItem(
                icon: Icons.settings,
                title: 'Configuración del Establecimiento',
                onTap: () {
                  Navigator.of(context).pushNamed('/establishmentSettings');
                },
              ),
            ],
          ),
        ),
      ],
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