import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/admin_debt_summary.dart';
import 'package:tf/services/api/credit_account_service.dart';
import 'package:tf/services/api/establishment_service.dart';
import 'package:tf/services/api/user_service.dart';

class AdminDebtSummaryPage extends StatefulWidget {
  const AdminDebtSummaryPage({super.key});

  @override
  State<AdminDebtSummaryPage> createState() => _AdminDebtSummaryPageState();
}

class _AdminDebtSummaryPageState extends State<AdminDebtSummaryPage> {
  List<AdminDebtSummary> _debtSummary = [];
  bool _hasClients = true;

  @override
  void initState() {
    super.initState();
    _loadDebtSummary();
  }
 Future<void> _loadDebtSummary() async {
    final creditAccountService = context.read<CreditAccountService>();
    final establishmentService = context.read<EstablishmentService>();
    final userService = context.read<UserService>();

    // Fetch the user and token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      try {
        final user = await userService.getUserByIdU(userId, accessToken);
        if (user == null) {
          throw Exception('User not found');
        }
        if (user.id == null) {
          throw Exception('User ID not found');
        }
        final establishment = await establishmentService
            .getEstablishmentByAdminId(user.id ?? 0, accessToken);
        if (establishment != null) {
          final establishmentId = establishment.id;
          final debtSummary = await creditAccountService
              .getAdminDebtSummary(establishmentId, accessToken);

          // Check if there are any clients in the debt summary
          setState(() {
            _debtSummary = debtSummary;
            _hasClients = debtSummary.isNotEmpty;
          });
        }
      } catch (e) {
        print("Error loading debt summary: $e");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Deudas'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: !_hasClients
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 64,
                    color: Colors.green, 
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¡No hay clientes!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: (){
                      _loadDebtSummary();
                    }, 
                    child: const Text('Recargar')
                  )
                ],
              ),
            )
          : _debtSummary.isEmpty
              ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 64,
                    color: Colors.green, 
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¡No hay clientes!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: (){
                      _loadDebtSummary();
                    }, 
                    child: const Text('Recargar')
                  )
                ],
              ),
            )
              : ListView.builder(
              itemCount: _debtSummary.length,
              itemBuilder: (context, index) {
                final summary = _debtSummary[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cliente: ${summary.clientName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Tipo de Crédito: ${summary.creditType}'),
                        const SizedBox(height: 8),
                        Text('Tasa de Interés: ${summary.interestRate}%'),
                        const SizedBox(height: 8),
                        Text('Saldo Actual: S/ ${summary.currentBalance}'),
                        const SizedBox(height: 8),
                        Text('Fecha de Vencimiento: ${summary.dueDate}'),
                        const SizedBox(height: 8),
                        if (summary.creditType == 'SHORT_TERM')
                          // Show short-term specific details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Días de Atraso: ${summary.daysOverdue}'),
                              const SizedBox(height: 8),
                              Text('Monto a Pagar: S/ ${summary.amountToPay}'),
                            ],
                          )
                        else if (summary.creditType == 'LONG_TERM')
                          // Show long-term specific details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Número de Cuotas: ${summary.numberOfDues}'),
                              const SizedBox(height: 8),
                              Text(
                                  'Próxima Cuota a Vencer: ${summary.nextDueDate}'),
                            ],
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
