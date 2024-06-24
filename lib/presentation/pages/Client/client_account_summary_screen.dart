import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/cubits/account_summary_cubit.dart';
import 'package:tf/models/api/account_summary.dart'; 
import 'package:tf/models/api/installment_response.dart';
import 'package:tf/models/api/transaction_response.dart';


class ClientAccountSummaryScreen extends StatefulWidget {
  const ClientAccountSummaryScreen({super.key});

  @override
  State<ClientAccountSummaryScreen> createState() => _ClientAccountSummaryScreenState();
}

class _ClientAccountSummaryScreenState extends State<ClientAccountSummaryScreen> {
  @override
  void initState() {
    super.initState();
    _fetchAccountSummary();
  }

  Future<void> _fetchAccountSummary() async {
    final accountSummaryCubit = context.read<AccountSummaryCubit>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      accountSummaryCubit.fetchAccountSummary(accessToken);
    } else {
      print("Error: Access token is null"); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumen de Cuenta')),
      body: BlocBuilder<AccountSummaryCubit, AccountSummaryState>(
        builder: (context, state) {
          if (state is AccountSummaryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AccountSummaryLoaded) {
            return _buildSummaryContent(state.accountSummary);
          } else if (state is AccountSummaryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink(); 
          }
        },
      ),
    );
  }

  Widget _buildSummaryContent(AccountSummary accountSummary) {
    return SingleChildScrollView( // To make content scrollable
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Credit Account Details
            _buildSectionTitle('Detalles de la Cuenta de Crédito'),
            _buildDetailRow('Límite de Crédito:', 'S/ ${accountSummary.creditAccount.creditLimit}'),
            _buildDetailRow('Saldo Actual:', 'S/ ${accountSummary.creditAccount.currentBalance}'),
            _buildDetailRow('Fecha de Vencimiento Mensual:', '${accountSummary.creditAccount.monthlyDueDate}'),
            // ... add other credit account details ...

            // Summary Data
            const SizedBox(height: 24),
            _buildSectionTitle('Resumen de la Cuenta'),
            _buildDetailRow('Compras Totales:', 'S/ ${accountSummary.totalPurchases}'),
            _buildDetailRow('Pagos Totales:', 'S/ ${accountSummary.totalPayments}'),
            _buildDetailRow('Interés Total:', 'S/ ${accountSummary.totalInterest}'),
            _buildDetailRow('Cuotas Pendientes:', '${accountSummary.outstandingDues}'),

            // Transactions (if available)
            if (accountSummary.transactions.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Transacciones Recientes'),
              _buildTransactionList(accountSummary.transactions),
            ],

            // Installments (if applicable)
            if (accountSummary.creditAccount.creditType == 'LONG_TERM' && accountSummary.outstandingInstallments.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Cuotas Pendientes'),
              _buildInstallmentList(accountSummary.outstandingInstallments),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  // Widget to build the transaction list
  Widget _buildTransactionList(List<TransactionResponse> transactions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          title: Text(transaction.transactionType), // Display the type of transaction
          trailing: Text('S/ ${transaction.amount}'),
          // ... Add other transaction details as needed
        );
      },
    );
  }

  // Widget to build the installment list (for long-term credit)
  Widget _buildInstallmentList(List<InstallmentResponse> installments) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: installments.length,
      itemBuilder: (context, index) {
        final installment = installments[index];
        return ListTile(
          title: Text('Cuota ${index + 1}'),
          subtitle: Text('Fecha de vencimiento: ${installment.dueDate}'),
          trailing: Text('S/ ${installment.amount}'),
        );
      },
    );
  }
}