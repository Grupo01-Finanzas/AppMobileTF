import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tf/cubits/transaction_cubit.dart';
import 'package:tf/repository/transaction_repository.dart';


class ManageTransactionsPage extends StatelessWidget {
  const ManageTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit(transactionRepository: context.read<TransactionRepository>()),
      child: const ManageTransactionsView(), 
    );
  }
}

class ManageTransactionsView extends StatefulWidget {
  const ManageTransactionsView({super.key});

  @override
  State<ManageTransactionsView> createState() => _ManageTransactionsViewState();
}

class _ManageTransactionsViewState extends State<ManageTransactionsView> {
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    context.read<TransactionCubit>().fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Transactions')),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return ListTile(
                  title: Text('Transaction ID: ${transaction.id}'),
                  subtitle: Text('Amount: ${transaction.amount}'),
                  
                );
              },
            );
          } else if (state is TransactionError) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                ElevatedButton(
                  onPressed: _fetchTransactions,
                  child: const Text('Retry'),
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/home');
                  }, 
                  child: const Text('Go Back')
                ),

              ]));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}