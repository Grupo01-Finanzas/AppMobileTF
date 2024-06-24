import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/cubits/pay_debt_cubit.dart';
import 'package:tf/enum/payment_method.dart';
import 'package:tf/enum/transaction_type.dart';
import 'package:tf/repository/transaction_repository.dart';


class ClientPayDebtScreen extends StatefulWidget {
  const ClientPayDebtScreen({super.key});

  @override
  State<ClientPayDebtScreen> createState() => _ClientPayDebtScreenState();
}

class _ClientPayDebtScreenState extends State<ClientPayDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.CASH;

  @override
  void dispose() {
    _amountController.dispose();
    _confirmationCodeController.dispose();
    super.dispose();
  }

  Future<void> _payDebt() async {
    if (_formKey.currentState!.validate()) {
      final payDebtCubit = context.read<PayDebtCubit>();
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final userId = prefs.getInt('userId'); // Assuming you have the client's user ID

      if (accessToken != null && userId != null) {
        try {
          await payDebtCubit.payDebt(
            creditAccountId: userId, // Assuming the client's user ID is the same as their CreditAccountID
            transactionType: TransactionType.PAYMENT,
            amount: double.parse(_amountController.text),
            paymentMethod: _selectedPaymentMethod,
            confirmationCode: _confirmationCodeController.text,
            accessToken: accessToken,
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pago realizado con éxito!')),
          );

          // You might want to navigate back or refresh the client's balance
          // after successful payment
          Navigator.pop(context);
        } catch (e) {
          print("Error paying debt: $e");
          // Handle error, maybe show a SnackBar
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PayDebtCubit(transactionRepository: context.read<TransactionRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pagar Deuda')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto a Pagar',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un monto';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, ingrese un monto válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Payment Method
                const Text('Método de Pago:', style: TextStyle(fontSize: 16)),
                RadioListTile(
                  title: const Text('Efectivo'),
                  value: PaymentMethod.CASH,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Yape'),
                  value: PaymentMethod.YAPE,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Plin'),
                  value: PaymentMethod.PLIN,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),

                // Confirmation Code (conditionally visible)
                if (_selectedPaymentMethod != PaymentMethod.CASH)
                  TextFormField(
                    controller: _confirmationCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Código de Confirmación',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese el código de confirmación';
                      }
                      return null;
                    },
                  ),

                const SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _payDebt,
                    child: const Text('Pagar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}