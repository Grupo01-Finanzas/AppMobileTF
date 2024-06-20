import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/client.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/client_service.dart';


class ManageClientsScreen extends StatefulWidget {
  const ManageClientsScreen({super.key});

  @override
  State<ManageClientsScreen> createState() => _ManageClientsScreenState();
}

class _ManageClientsScreenState extends State<ManageClientsScreen> {
  late Future<List<Client>> _clientsFuture;
  List<Client> _filteredClients = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clientService = context.read<ClientService>();
    final authService = context.read<AuthenticationService>();
    final adminService = context.read<AdminService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        _clientsFuture = clientService.getClientsByEstablishmentId(establishmentId);
        _clientsFuture.then((clients) {
          setState(() {
            _filteredClients = clients;
          });
        });
      }
    }
  }

 void _filterClients() {
    _clientsFuture.then((clients) {
      setState(() {
        _filteredClients = clients
            .where((client) => client.user?.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ??
                false)
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Clientes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _filterClients();
              },
              decoration: const InputDecoration(
                hintText: 'Buscar cliente por nombre...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Client>>(
              future: _clientsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = _filteredClients[index];
                      return _buildClientTile(client);
                    },
                  );
                } else {
                  return const Center(child: Text('No se encontraron clientes'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientTile(Client client) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(client.user!.photoUrl),
        ),
        title: Text(client.user!.name),
        subtitle: Text(client.user!.email),
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            switch (action) {
              case 'details':
                _showClientDetails(client);
                break;
              // Agregar más acciones aquí
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'details',
              child: Text('Ver Detalles'),
            ),
            // Agregar más opciones aquí
          ],
        ),
      ),
    );
  }

  void _showClientDetails(Client client) {
    Navigator.of(context).pushNamed('/clientDetails', arguments: client.id);
  }
}