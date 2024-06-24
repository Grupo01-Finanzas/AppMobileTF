import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/credit_account.dart';
import 'package:tf/services/api/credit_account_service.dart';

class InterestRateSettingsPage extends StatefulWidget {
  final CreditAccount creditAccount;

  const InterestRateSettingsPage({super.key, required this.creditAccount});

  @override
  State<InterestRateSettingsPage> createState() =>
      _InterestRateSettingsPageState();
}

class _InterestRateSettingsPageState extends State<InterestRateSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _interestRateController = TextEditingController();
  final _lateFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInterestRates();
  }

  Future<void> _loadInterestRates() async {
    final prefs = await SharedPreferences.getInstance();

    // Determine which rates to load based on creditAccount.creditType
    if (widget.creditAccount.creditType == 'SHORT_TERM') {
      _interestRateController.text =
          prefs.getDouble('shortTermRate')?.toString() ?? '';
      _lateFeeController.text =
          prefs.getDouble('shortTermLateFee')?.toString() ?? '';
    } else if (widget.creditAccount.creditType == 'LONG_TERM') {
      _interestRateController.text =
          prefs.getDouble('longTermRate')?.toString() ?? '';
      _lateFeeController.text =
          prefs.getDouble('longTermLateFee')?.toString() ?? '';
    }
  }

  Future<void> _saveInterestRates() async {
    if (_formKey.currentState!.validate()) {
      final creditAccountService = context.read<CreditAccountService>();
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken != null) {
        try {
          // Update interest rates in the API based on credit type
          if (widget.creditAccount.creditType == 'SHORT_TERM') {
            await creditAccountService.updateCreditAccount(
              creditAccountId: widget.creditAccount.id,
              creditLimit: widget.creditAccount.creditLimit,
              monthlyDueDate: widget.creditAccount.monthlyDueDate,
              interestRate: double.parse(_interestRateController.text),
              interestType: widget.creditAccount.interestType,
              creditType: widget.creditAccount.creditType,
              isBlocked: widget.creditAccount.isBlocked,
              accessToken: accessToken,
            );
            await prefs.setDouble(
                'shortTermRate', double.parse(_interestRateController.text));
            await prefs.setDouble(
                'shortTermLateFee', double.parse(_lateFeeController.text));
          } else if (widget.creditAccount.creditType == 'LONG_TERM') {
            await creditAccountService.updateCreditAccount(
              creditAccountId: widget.creditAccount.id,
              creditLimit: widget.creditAccount.creditLimit,
              monthlyDueDate: widget.creditAccount.monthlyDueDate,
              interestRate: double.parse(_interestRateController.text),
              interestType: widget.creditAccount.interestType,
              creditType: widget.creditAccount.creditType,
              isBlocked: widget.creditAccount.isBlocked,
              accessToken: accessToken,
            );
            await prefs.setDouble(
                'longTermRate', double.parse(_interestRateController.text));
            await prefs.setDouble(
                'longTermLateFee', double.parse(_lateFeeController.text));
          }

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Tasas de interés actualizadas correctamente')),
          );
        } catch (e) {
          print('Error saving interest rates: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Error al actualizar las tasas de interés: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Tasas de Interés')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interest Rate
              TextFormField(
                controller: _interestRateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      'Tasa de Interés (${widget.creditAccount.creditType == 'SHORT_TERM' ? 'Corto Plazo' : 'Largo Plazo'}) (%)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una tasa de interés';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un valor numérico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Late Fee
              TextFormField(
                controller: _lateFeeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      'Cargo por Mora (${widget.creditAccount.creditType == 'SHORT_TERM' ? 'Corto Plazo' : 'Largo Plazo'}) (%)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un cargo por mora';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un valor numérico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _saveInterestRates,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}