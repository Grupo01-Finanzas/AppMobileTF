import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/transaction.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/purchase_service.dart';


class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final purchaseService = context.read<PurchaseService>();
    final userId =
        (await context.read<AuthenticationService>().getCurrentUser())?.id ?? 0;
    _transactionsFuture = purchaseService.getClientTransactions(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Transacciones')),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final transactions = snapshot.data!;
            return _buildTransactionList(transactions);
          } else {
            return const Center(child: Text('No transactions found'));
          }
        },
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: Icon(_getTransactionIcon(transaction.transactionType)),
          title: Text(transaction.description),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd/MM/yyyy HH:mm').format(transaction.createdAt)),
              Text(
                currencyFormat.format(transaction.amount),
                style: TextStyle(
                  color: transaction.amount > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
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