import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/transaction_response.dart';
import 'package:tf/services/api/purchase_service.dart'; 

class ClientTransactionsHistoryScreen extends StatefulWidget {
  const ClientTransactionsHistoryScreen({super.key});

  @override
  State<ClientTransactionsHistoryScreen> createState() =>
      _ClientTransactionsHistoryScreenState();
}

class _ClientTransactionsHistoryScreenState
    extends State<ClientTransactionsHistoryScreen> {
  List<TransactionResponse> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final purchaseService = context.read<PurchaseService>();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      final transactions = await purchaseService.getClientTransactionsU(
        userId,
        accessToken,
      );
      setState(() {
        _transactions = transactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _transactions.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  title: Text(transaction.description ?? 'Sin descripción'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'S/ ${transaction.amount}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${transaction.transactionDate}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Text(transaction.transactionType),
                );
              },
            ),
    );
  }
}