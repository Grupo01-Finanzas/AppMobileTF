import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/admin_debt_summary.dart';
import 'package:tf/services/admin_service.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/credit_account_service.dart';


class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  late Future<List<AdminDebtSummary>> _debtSummaryFuture;

  @override
  void initState() {
    super.initState();
    _loadDebtSummary();
  }

  Future<void> _loadDebtSummary() async {
    final creditAccountService = context.read<CreditAccountService>();
    final adminService = context.read<AdminService>();
    final authService = context.read<AuthenticationService>();

    final user = await authService.getCurrentUser();
    if (user != null) {
      final admin = await adminService.getAdmin(user.id);
      if (admin != null) {
        final establishmentId = admin.establishmentId;
        _debtSummaryFuture = creditAccountService.getAdminDebtSummary(establishmentId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Reportes del Establecimiento')),
      body: FutureBuilder<List<AdminDebtSummary>>(
        future: _debtSummaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final debtSummary = snapshot.data!;
            return _buildDebtSummaryList(debtSummary, currencyFormat);
          } else {
            return const Center(child: Text('No se encontraron reportes'));
          }
        },
      ),
    );
  }

  Widget _buildDebtSummaryList(
      List<AdminDebtSummary> debtSummary, NumberFormat currencyFormat) {
    return ListView.builder(
      itemCount: debtSummary.length,
      itemBuilder: (context, index) {
        final summaryItem = debtSummary[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text('Cliente: ${summaryItem.clientName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipo de Crédito: ${summaryItem.creditType}'),
                Text('Tasa de Interés: ${summaryItem.interestRate}%'),
                if (summaryItem.creditType == 'LONG_TERM')
                  Text('Número de Cuotas: ${summaryItem.numberOfDues}'),
                Text(
                  'Saldo Actual: ${currencyFormat.format(summaryItem.currentBalance)}',
                ),
                Text(
                  'Fecha de Vencimiento: ${DateFormat('dd/MM/yyyy').format(summaryItem.dueDate)}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}