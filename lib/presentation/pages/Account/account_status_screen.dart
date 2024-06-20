import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/credit_account.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/purchase_service.dart';


class AccountStatusScreen extends StatefulWidget {
  const AccountStatusScreen({super.key});

  @override
  State<AccountStatusScreen> createState() => _AccountStatusScreenState();
}

class _AccountStatusScreenState extends State<AccountStatusScreen> {
  late Future<CreditAccount> _creditAccountFuture;

  @override
  void initState() {
    super.initState();
    _loadCreditAccount();
  }

  Future<void> _loadCreditAccount() async {
    final purchaseService = context.read<PurchaseService>();
    final userId =
        (await context.read<AuthenticationService>().getCurrentUser())?.id ?? 0;
    _creditAccountFuture = purchaseService.getClientCreditAccount(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estado de Cuenta')),
      body: FutureBuilder<CreditAccount>(
        future: _creditAccountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final creditAccount = snapshot.data!;
            return _buildAccountDetails(creditAccount);
          } else {
            return const Center(child: Text('No credit account found'));
          }
        },
      ),
    );
  }

  Widget _buildAccountDetails(CreditAccount creditAccount) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dueDate = DateTime.now().add(const Duration(days: 30)); // Ejemplo de fecha de vencimiento

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Número de Cuenta', creditAccount.id.toString()),
          _buildDetailRow('Saldo Actual',
              currencyFormat.format(creditAccount.currentBalance)),
          _buildDetailRow('Límite de Crédito',
              currencyFormat.format(creditAccount.creditLimit)),
          _buildDetailRow(
              'Próximo Pago', DateFormat('dd/MM/yyyy').format(dueDate)),
          _buildDetailRow('Tipo de Crédito', creditAccount.creditType),
          const SizedBox(height: 16.0),
          const Divider(),
          const SizedBox(height: 16.0),
          const Text(
            'Deudas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          FutureBuilder<double>(
            future:
                context.read<PurchaseService>().getClientOverdueBalance(creditAccount.clientId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final overdueBalance = snapshot.data!;
                return _buildDetailRow('Saldo Vencido',
                    currencyFormat.format(overdueBalance));
              } else {
                return const Text('No overdue balance found');
              }
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/payDebt'),
            child: const Text('Pagar Deudas'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:'),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}