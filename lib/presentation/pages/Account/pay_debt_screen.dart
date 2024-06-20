import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/credit_account.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/credit_account_service.dart';
import 'package:tf/services/purchase_service.dart';


class PayDebtScreen extends StatefulWidget {
  const PayDebtScreen({super.key});

  @override
  State<PayDebtScreen> createState() => _PayDebtScreenState();
}

class _PayDebtScreenState extends State<PayDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  late Future<CreditAccount> _creditAccountFuture;
  bool _isLoading = false;

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
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Pagar Deudas')),
      body: FutureBuilder<CreditAccount>(
        future: _creditAccountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final creditAccount = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deuda Total: ${currencyFormat.format(creditAccount.currentBalance)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Monto a Pagar',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un monto';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Ingresa un monto válido';
                        }
                        if (amount > creditAccount.currentBalance) {
                          return 'El monto no puede ser mayor a la deuda total';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    final amount =
                                        double.parse(_amountController.text);
                                    await context
                                        .read<CreditAccountService>()
                                        .processPayment(
                                          creditAccount.id,
                                          amount,
                                          'Pago de deuda',
                                        );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Pago realizado con éxito!'),
                                        ),
                                      );
                                    // Actualiza el estado de la cuenta
                                    await _loadCreditAccount();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text('Error: $e'),
                                        ),
                                      );
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Pagar'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No se encontró una cuenta de crédito'));
          }
        },
      ),
    );
  }
}