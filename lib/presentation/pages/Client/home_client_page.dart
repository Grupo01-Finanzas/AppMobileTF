import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/credit_request.dart';
import 'package:tf/models/user.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/credit_request_service.dart';

class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  int _unreadNotificationCount = 0;
  List<CreditRequest> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final creditRequestService = context.read<CreditRequestService>();
    final userId =
        (await context.read<AuthenticationService>().getCurrentUser())?.id ?? 0;
    final notifications =
        await creditRequestService.getCreditRequestsByClientId(userId);
    setState(() {
      _notifications = notifications;
      _unreadNotificationCount = notifications
          .where((notification) => !notification.read)
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User?>(
          future: context.read<AuthenticationService>().getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text('Error loading user');
            } else if (snapshot.hasData) {
              return Text('Hey, ${snapshot.data!.name}');
            } else {
              return const Text('Hey, Guest');
            }
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  _showNotificationsModal(context);
                },
                icon: const Icon(Icons.notifications),
              ),
              if (_unreadNotificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$_unreadNotificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
      body: const BuildGrid(),
    );
  }

  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      title: Text('Credit Request ${notification.status}'),
                      subtitle: Text(
                          'Request ID: ${notification.id}, Client ID: ${notification.clientId}'),
                      tileColor: notification.read
                          ? Colors.grey[200]
                          : Colors.white,
                      onTap: () {
                        setState(() {
                          // Actualiza el estado de lectura en el modelo
                          notification.read = true; 

                          // Actualiza el contador de notificaciones no leídas
                          if (!notification.read) {
                            _unreadNotificationCount--;
                          }
                        });
                        // Navegar a la vista de detalles del Credit Request
                        Navigator.of(context).pushNamed(
                          '/creditRequestDetails',
                          arguments: notification,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BuildGrid extends StatelessWidget {
  const BuildGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16.0),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: [
        _buildGridItem(
          icon: Icons.account_balance_wallet,
          title: 'Estado de Cuenta',
          onTap: () => Navigator.of(context).pushNamed('/accountStatus'),
        ),
        _buildGridItem(
          icon: Icons.history,
          title: 'Historial de movimientos',
          onTap: () => Navigator.of(context).pushNamed('/transactionHistory'),
        ),
        _buildGridItem(
          icon: Icons.payment,
          title: 'Pagar Deudas',
          onTap: () => Navigator.of(context).pushNamed('/payDebt'),
        ),
        _buildGridItem(
          icon: Icons.calendar_today,
          title: 'Cambiar Fecha de Pago',
          onTap: () => Navigator.of(context).pushNamed('/changePaymentDate'),
        ),
      ],
    );
  }
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