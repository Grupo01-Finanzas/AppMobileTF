import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/account_statement_response.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/credit_account_service.dart';



class CreditAccountHistoryPage extends StatefulWidget {
  const CreditAccountHistoryPage({super.key});

  @override
  State<CreditAccountHistoryPage> createState() =>
      _CreditAccountHistoryPageState();
}

class _CreditAccountHistoryPageState extends State<CreditAccountHistoryPage> {
  late Future<AccountStatementResponse> _accountHistoryFuture;

  @override
  void initState() {
    super.initState();
    _loadAccountHistory();
  }

  Future<void> _loadAccountHistory() async {
    final creditAccountService = context.read<CreditAccountService>();
    final userId =
        (await context.read<AuthenticationService>().getCurrentUser())?.id ?? 0;
    _accountHistoryFuture = creditAccountService.getClientAccountHistory(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Cuenta'),
      ),
      body: FutureBuilder<AccountStatementResponse>(
        future: _accountHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final accountHistory = snapshot.data!;
            return _buildHistoryList(accountHistory);
          } else {
            return const Center(
                child: Text('No se encontró historial de cuenta'));
          }
        },
      ),
    );
  }

  Widget _buildHistoryList(AccountStatementResponse accountHistory) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return ListView.builder(
      itemCount: accountHistory.transactions.length + 1, // +1 para mostrar el saldo inicial
      itemBuilder: (context, index) {
        if (index == 0) {
          // Mostrar el saldo inicial
          return ListTile(
            title: const Text('Saldo Inicial'),
            trailing: Text(
              currencyFormat.format(accountHistory.startingBalance),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          // Mostrar las transacciones
          final transaction =
              accountHistory.transactions[index - 1]; // Ajustar el índice
          return ListTile(
            leading:
                Icon(_getTransactionIcon(transaction.transactionType)),
            title: Text(transaction.description),
            subtitle: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(transaction.createdAt)),
            trailing: Text(
              currencyFormat.format(transaction.amount),
              style: TextStyle(
                color: transaction.amount > 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }

  IconData _getTransactionIcon(String transactionType) {
    switch (transactionType) {
      case 'PURCHASE':
        return Icons.shopping_cart;
      case 'PAYMENT':
        return Icons.payment;
      case 'INTEREST_ACCRUAL':
        return Icons.attach_money;
      case 'LATE_FEE_APPLIED':
        return Icons.warning;
      default:
        return Icons.money;
    }
  }
}