import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/cubits/transaction_cubit.dart';
import 'package:tf/enum/payment_method.dart';


class ClientTransactionsPage extends StatelessWidget {
  const ClientTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionCubit(transactionRepository: context.read()),
      child: const ClientTransactionsView(),
    );
  }
}

class ClientTransactionsView extends StatefulWidget {
  const ClientTransactionsView({super.key});

  @override
  State<ClientTransactionsView> createState() => _ClientTransactionsViewState();
}

class _ClientTransactionsViewState extends State<ClientTransactionsView> {
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final transactionCubit = context.read<TransactionCubit>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userId = prefs.getInt('userId');

    if (accessToken != null && userId != null) {
      transactionCubit.fetchTransactionsId(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Transacciones')),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      '${transaction.transactionType} - S/ ${transaction.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha: ${transaction.transactionDate}'),
                        Text('Descripción: ${transaction.description}'),
                        Text('Método de Pago: ${transaction.paymentMethod}'),
                        if (transaction.paymentMethod !=
                            PaymentMethod.CASH.name)
                          Text('Código de Confirmación: ${transaction.paymentCode}'),
                        Text('Estado: ${transaction.paymentStatus}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TransactionError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}