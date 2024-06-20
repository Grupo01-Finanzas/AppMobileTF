import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tf/models/credit_account.dart';
import 'package:tf/models/credit_request.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/credit_request_service.dart';
import 'package:tf/services/purchase_service.dart';


class ChangePaymentDateScreen extends StatefulWidget {
  const ChangePaymentDateScreen({super.key});

  @override
  State<ChangePaymentDateScreen> createState() =>
      _ChangePaymentDateScreenState();
}

class _ChangePaymentDateScreenState extends State<ChangePaymentDateScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  late Future<CreditAccount> _creditAccountFuture;
  bool _isLoading = false;
  final TextEditingController _reasonController = TextEditingController();

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
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Fecha de Pago')),
      body: FutureBuilder<CreditAccount>(
        future: _creditAccountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final creditAccount = snapshot.data!;
            return _buildForm(creditAccount);
          } else {
            return const Center(
                child: Text('No se encontró una cuenta de crédito'));
          }
        },
      ),
    );
  }

  Widget _buildForm(CreditAccount creditAccount) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha Actual de Pago: ${DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 30)))}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                'Seleccionar Nueva Fecha: ${_selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Selecciona una fecha'}',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Motivo del Cambio (Opcional)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading || _selectedDate == null
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await _submitChangeRequest(creditAccount);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Solicitud de cambio de fecha enviada!'),
                                ),
                              );
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(content: Text('Error: $e')),
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
                    : const Text('Enviar Solicitud'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitChangeRequest(CreditAccount creditAccount) async {
    final creditRequestService = context.read<CreditRequestService>();
    final userId =
        (await context.read<AuthenticationService>().getCurrentUser())?.id ?? 0;

    final newCreditRequest = CreditRequest(
      id: creditAccount.id,
      clientId: userId,
      establishmentId: creditAccount.establishmentId,
      requestedCreditLimit: creditAccount.creditLimit,
      monthlyDueDate: _selectedDate!.day,
      interestType: creditAccount.interestType,
      creditType: creditAccount.creditType,
      gracePeriod: creditAccount.gracePeriod,
      read: false, 
      status: 'PENDING', 
      createdAt: DateTime.now(), 
      updatedAt: DateTime.now(),
      
    );

    if (_selectedDate != null) {
        await creditRequestService.updateCreditRequestDueDate(
            newCreditRequest.id, _selectedDate!
        ); 
    } else {
        throw Exception('Please select a new due date.');
    }

  }
}