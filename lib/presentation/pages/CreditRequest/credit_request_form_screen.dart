import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/credit_request.dart';
import 'package:tf/services/authentication_service.dart';
import 'package:tf/services/credit_request_service.dart';
import 'package:tf/services/purchase_service.dart';



class CreditRequestFormScreen extends StatefulWidget {
  final String creditType;
  final Map<int, int> cartItems;

  const CreditRequestFormScreen({super.key, required this.creditType, required this.cartItems});

  @override
  State<CreditRequestFormScreen> createState() =>
      _CreditRequestFormScreenState();
}

class _CreditRequestFormScreenState extends State<CreditRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _requestedCreditLimitController = TextEditingController();
  final _monthlyDueDateController = TextEditingController();
  final _interestTypeController = TextEditingController();
  final _gracePeriodController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _requestedCreditLimitController.dispose();
    _monthlyDueDateController.dispose();
    _interestTypeController.dispose();
    _gracePeriodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Solicitar Crédito ${widget.creditType}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.creditType == 'SHORT_TERM') ...[
                  TextFormField(
                    controller: _requestedCreditLimitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Límite de Crédito Solicitado',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un límite de crédito';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Ingresa un límite de crédito válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _monthlyDueDateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Día de Pago Mensual (1-31)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un día de pago';
                      }
                      final day = int.tryParse(value);
                      if (day == null || day < 1 || day > 31) {
                        return 'Ingresa un día de pago válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Agrega más campos según tus necesidades
                ] else if (widget.creditType == 'LONG_TERM') ...[
                  TextFormField(
                    controller: _requestedCreditLimitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Límite de Crédito Solicitado',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un límite de crédito';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Ingresa un límite de crédito válido';
                      }
                      return null;
                    },
                  ),

                  
                  const SizedBox(height: 16.0),
                  
                ],
                TextFormField(
                  controller: _interestTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Interés',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un tipo de interés';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _gracePeriodController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Periodo de Gracia (en meses)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un periodo de gracia';
                    }
                    final gracePeriod = int.tryParse(value);
                    if (gracePeriod == null || gracePeriod < 0) {
                      return 'Ingresa un periodo de gracia válido';
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
                                await _submitCreditRequest();
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Solicitud de crédito enviada!'),
                                    ),
                                  );
                                Navigator.of(context).pop(); // Cierra el formulario después de enviar
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
        ),
      ),
    );
  }

  Future<void> _submitCreditRequest() async {
    final creditRequestService = context.read<CreditRequestService>();
    final purchaseService = context.read<PurchaseService>();
    final userId =
        (await context.read<AuthenticationService>().getCurrentUser())?.id ?? 0;
    final creditAccount = await purchaseService.getClientCreditAccount(userId);
    final establishmentId = creditAccount.establishmentId;

    final newCreditRequest = CreditRequest(
      clientId: userId,
      establishmentId: establishmentId,
      requestedCreditLimit:
          double.parse(_requestedCreditLimitController.text),
      monthlyDueDate: int.parse(_monthlyDueDateController.text),
      interestType: _interestTypeController.text,
      creditType: widget.creditType,
      gracePeriod: int.parse(_gracePeriodController.text),
      status: 'PENDING',
      read: false,
      id: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await creditRequestService.createCreditRequest(
      newCreditRequest.clientId,
      newCreditRequest.establishmentId,
      newCreditRequest.requestedCreditLimit,
      newCreditRequest.monthlyDueDate,
      newCreditRequest.interestType,
      newCreditRequest.creditType,
      newCreditRequest.gracePeriod,
    ); 
  }

}