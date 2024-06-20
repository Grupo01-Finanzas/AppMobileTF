import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/client.dart';
import 'package:tf/models/credit_request.dart';
import 'package:tf/models/credit_requests_status.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/client_service.dart';
import 'package:tf/services/credit_request_service.dart';


class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() =>
      _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  late Future<List<CreditRequest>> _creditRequestsFuture;
  List<CreditRequest> _filteredCreditRequests = [];
  CreditRequestStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _loadCreditRequests();
  }

  Future<void> _loadCreditRequests() async {
    final creditRequestService = context.read<CreditRequestService>();
    final adminService = context.read<AdminService>();
    final authService = context.read<AuthenticationService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        _creditRequestsFuture = creditRequestService
            .getCreditRequestsByEstablishmentId(establishmentId)
            .then((creditRequests) {
          
          setState(() {
            _filteredCreditRequests = creditRequests.where((request) =>
                _selectedStatusFilter == null ||
                request.status == _selectedStatusFilter!.name).toList();
          });
          return _filteredCreditRequests;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<CreditRequestStatus>(
              value: _selectedStatusFilter,
              onChanged: (status) {
                setState(() {
                  _selectedStatusFilter = status;
                });
                _loadCreditRequests(); // Recarga las solicitudes al cambiar el filtro
              },
              items: CreditRequestStatus.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.name),
                      ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Filtrar por Estado',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CreditRequest>>(
              future: _creditRequestsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _filteredCreditRequests.length,
                    itemBuilder: (context, index) {
                      final creditRequest = _filteredCreditRequests[index];
                      return _buildCreditRequestTile(creditRequest);
                    },
                  );
                } else {
                  return const Center(
                      child: Text('No se encontraron solicitudes de crédito'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditRequestTile(CreditRequest creditRequest) {
    final clientService = context.read<ClientService>();

    return FutureBuilder<Client?>(
      future: clientService.getClientById(creditRequest.clientId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text('Cargando...'),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final client = snapshot.data;
          final clientName = client?.user?.name ?? 'Unknown';
          final formattedDate =
              DateFormat('dd/MM/yyyy HH:mm').format(creditRequest.createdAt);

          return Card(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text('Cliente: $clientName'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monto: \$${creditRequest.requestedCreditLimit}'),
                  Text('Tipo de crédito: ${creditRequest.creditType}'),
                  Text('Fecha: $formattedDate'),
                ],
              ),
              trailing: _buildStatusIcon(creditRequest.status),
              onTap: () => _showCreditRequestDetails(creditRequest),
            ),
          );
        } else {
          return const ListTile(
            title: Text('Cliente no encontrado'),
          );
        }
      },
    );
  }

  Widget _buildStatusIcon(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'PENDING':
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
      case 'APPROVED':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'REJECTED':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.question_mark;
    }

    return Icon(icon, color: color);
  }

  void _showCreditRequestDetails(CreditRequest creditRequest) {
    Navigator.of(context).pushNamed('/creditRequestDetails',
        arguments: creditRequest.id);
  }
}