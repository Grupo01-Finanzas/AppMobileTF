import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/credit_account.dart'; 
import 'package:tf/services/api/credit_account_service.dart'; 

class ClientAccountSummaryScreen extends StatefulWidget {
  const ClientAccountSummaryScreen({super.key});

  @override
  State<ClientAccountSummaryScreen> createState() =>
      _ClientAccountSummaryScreenState();
}

class _ClientAccountSummaryScreenState
    extends State<ClientAccountSummaryScreen> {
  CreditAccount? _creditAccount;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCreditAccount();
  }

  Future<void> _loadCreditAccount() async {
    final creditAccountService = context.read<CreditAccountService>();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final accessToken = prefs.getString('accessToken');

    if (userId != null && accessToken != null) {
      final creditAccount = await creditAccountService
          .getCreditAccountByClientId(userId, accessToken);
      setState(() {
        _creditAccount = creditAccount;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Cuenta'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _creditAccount == null
              ? const Center(
                  child: Text('No se encontró la cuenta'),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumen de Cuenta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Límite de Crédito: S/ ${_creditAccount!.creditLimit}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Saldo Actual: S/ ${_creditAccount!.currentBalance}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fecha de Vencimiento Mensual: ${_creditAccount!.monthlyDueDate}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tasa de Interés: ${_creditAccount!.interestRate}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tipo de Crédito: ${_creditAccount!.creditType}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (_creditAccount!.creditType == 'LONG_TERM')
                        Text(
                          'Periodo de Gracia: ${_creditAccount!.gracePeriod} meses',
                          style: const TextStyle(fontSize: 16),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to a screen to view detailed transactions
                          Navigator.pushNamed(
                            context,
                            '/clientTransactionsHistory',
                          );
                        },
                        child: const Text('Ver Historial de Transacciones'),
                      ),
                    ],
                  ),
                ),
    );
  }
}