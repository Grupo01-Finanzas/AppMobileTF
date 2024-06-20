import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/credit_account.dart';
import 'package:tf/models/credit_requests_status.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/credit_account_service.dart';
import 'package:tf/services/credit_request_service.dart';


class ManageCreditAccountsScreen extends StatefulWidget {
  const ManageCreditAccountsScreen({super.key});

  @override
  State<ManageCreditAccountsScreen> createState() =>
      _ManageCreditAccountsScreenState();
}

class _ManageCreditAccountsScreenState
    extends State<ManageCreditAccountsScreen> {
  late Future<List<CreditAccount>> _creditAccountsFuture;
  List<CreditAccount> _filteredCreditAccounts = [];
  String _searchQuery = '';
  CreditRequestStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _loadCreditAccounts();
  }

  Future<void> _loadCreditAccounts() async {
    final creditAccountService = context.read<CreditAccountService>();
    final adminService = context.read<AdminService>();
    final authService = context.read<AuthenticationService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        _creditAccountsFuture = creditAccountService
            .getCreditAccountsByEstablishmentId(establishmentId)
            .then((creditAccounts) {
          // Filtra dentro del then
          setState(() {
            _filteredCreditAccounts = creditAccounts.where((account) =>
                account.client!.user!.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) &&
                (_selectedStatusFilter == null ||
                    account.creditRequests.any((request) =>
                        request.status == _selectedStatusFilter!.name))).toList();
          });
          return _filteredCreditAccounts; // Devuelve la lista filtrada
        });
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Cuentas de Crédito')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                    _loadCreditAccounts(); // Recarga las cuentas al cambiar la búsqueda
                  },
                  decoration: const InputDecoration(
                    hintText: 'Buscar cliente...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<CreditRequestStatus>(
                  value: _selectedStatusFilter,
                  onChanged: (status) {
                    setState(() {
                      _selectedStatusFilter = status;
                    });
                    _loadCreditAccounts(); // Recarga las cuentas al cambiar el filtro
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
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CreditAccount>>(
              future: _creditAccountsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  // La lista ya está filtrada en _loadCreditAccounts
                  final creditAccounts = snapshot.data!; 
                  return ListView.builder(
                    itemCount: creditAccounts.length,
                    itemBuilder: (context, index) {
                      final creditAccount = creditAccounts[index];
                      return _buildCreditAccountTile(
                          creditAccount, currencyFormat);
                    },
                  );
                } else {
                  return const Center(
                      child: Text('No se encontraron cuentas de crédito'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditAccountTile(
      CreditAccount creditAccount, NumberFormat currencyFormat) {
    final clientName = creditAccount.client!.user!.name;
    final creditLimit = currencyFormat.format(creditAccount.creditLimit);
    final currentBalance =
        currencyFormat.format(creditAccount.currentBalance);
    final creditType = creditAccount.creditType;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text('Cliente: $clientName'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Límite: $creditLimit'),
            Text('Saldo: $currentBalance'),
            Text('Tipo: $creditType'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            switch (action) {
              case 'approve':
                _approveCreditRequest(creditAccount);
                break;
              case 'reject':
                _rejectCreditRequest(creditAccount);
                break;
              case 'details':
                _showCreditAccountDetails(creditAccount);
                break;
              // Agregar más acciones aquí
            }
          },
          itemBuilder: (context) => [
            if (creditAccount.creditRequests.any(
                (request) => request.status == CreditRequestStatus.pending.toString()))
              const PopupMenuItem(
                value: 'approve',
                child: Text('Aprobar Solicitud'),
              ),
            if (creditAccount.creditRequests.any(
                (request) => request.status == CreditRequestStatus.pending.toString()))
              const PopupMenuItem(
                value: 'reject',
                child: Text('Rechazar Solicitud'),
              ),
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

  Future<void> _approveCreditRequest(CreditAccount creditAccount) async {
    final creditRequestService = context.read<CreditRequestService>();
    final pendingRequestId = creditAccount.creditRequests
        .firstWhere((request) => request.status == CreditRequestStatus.pending.toString())
        .id;
    try {
      await creditRequestService.approveCreditRequest(pendingRequestId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud de crédito aprobada')),
      );
      _loadCreditAccounts(); // Recargar las cuentas de crédito
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al aprobar la solicitud: $e')),
      );
    }
  }

  Future<void> _rejectCreditRequest(CreditAccount creditAccount) async {
    final creditRequestService = context.read<CreditRequestService>();
    final pendingRequestId = creditAccount.creditRequests
        .firstWhere((request) => request.status == CreditRequestStatus.pending.toString())
        .id;
    try {
      await creditRequestService.rejectCreditRequest(pendingRequestId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud de crédito rechazada')),
      );
      _loadCreditAccounts(); // Recargar las cuentas de crédito
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al rechazar la solicitud: $e')),
      );
    }
  }

  void _showCreditAccountDetails(CreditAccount creditAccount) {
    Navigator.of(context).pushNamed('/creditAccountDetails',
        arguments: creditAccount.id);
  }
}
