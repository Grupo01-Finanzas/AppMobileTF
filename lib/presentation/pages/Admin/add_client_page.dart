import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/cubits/client_cubit.dart';
import 'package:tf/enum/credit_type.dart';
import 'package:tf/enum/interest_type.dart';


class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key});

  @override
  AddClientPageState createState() => AddClientPageState();
}

class AddClientPageState extends State<AddClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _dniController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _monthlyDueDateController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _gracePeriodController = TextEditingController();
  final _lateFeePercentageController = TextEditingController();

  CreditType _selectedCreditType = CreditType.SHORT_TERM;
  InterestType _selectedInterestType = InterestType.NOMINAL;

  @override
  void dispose() {
    _dniController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _creditLimitController.dispose();
    _monthlyDueDateController.dispose();
    _interestRateController.dispose();
    _gracePeriodController.dispose();
    _lateFeePercentageController.dispose();
    super.dispose();
  }

  Future<void> _addClient() async {
    if (_formKey.currentState!.validate()) {
      final clientCubit = context.read<ClientCubit>();
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final establishmentId = prefs.getInt('establishmentId');

      if (accessToken != null && establishmentId != null) {
        try {
          // Call the ClientCubit method to create the client
          await clientCubit.createClient(
            dni: _dniController.text,
            name: _nameController.text,
            address: _addressController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            password: _passwordController.text,
            creditLimit: double.parse(_creditLimitController.text),
            monthlyDueDate: int.parse(_monthlyDueDateController.text),
            interestRate: double.parse(_interestRateController.text),
            interestType: _selectedInterestType,
            creditType: _selectedCreditType,
            gracePeriod: int.parse(_gracePeriodController.text),
            lateFeePercentage: double.parse(_lateFeePercentageController.text),
            establishmentId: establishmentId,
            accessToken: accessToken,
          );

          // Navigate back to the client list screen
          context.pop();

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente agregado correctamente')),
          );
        } catch (e) {
          // Handle error, maybe show a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Cliente')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // To make the form scrollable
            child: Column(
              children: <Widget>[
                // ... [Your existing TextFormFields for DNI, name, address, phone, email, password] ...

                // Credit Limit
                TextFormField(
                  controller: _creditLimitController,
                  decoration:
                      const InputDecoration(labelText: 'Límite de Crédito'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el límite de crédito';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un valor numérico válido';
                    }
                    return null;
                  },
                ),

                // Monthly Due Date
                TextFormField(
                  controller: _monthlyDueDateController,
                  decoration: const InputDecoration(
                      labelText: 'Fecha de Vencimiento Mensual (1-31)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de vencimiento';
                    }
                    final dueDate = int.tryParse(value);
                    if (dueDate == null || dueDate < 1 || dueDate > 31) {
                      return 'Por favor ingrese un número entre 1 y 31';
                    }
                    return null;
                  },
                ),

                // Interest Rate
                TextFormField(
                  controller: _interestRateController,
                  decoration:
                      const InputDecoration(labelText: 'Tasa de Interés (%)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la tasa de interés';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un valor numérico válido';
                    }
                    return null;
                  },
                ),

                // Interest Type Dropdown
                DropdownButtonFormField<InterestType>(
                  value: _selectedInterestType,
                  decoration:
                      const InputDecoration(labelText: 'Tipo de Interés'),
                  items: InterestType.values.map((interestType) {
                    return DropdownMenuItem(
                      value: interestType,
                      child: Text(interestType.name), // Display the enum name
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedInterestType = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor seleccione un tipo de interés';
                    }
                    return null;
                  },
                ),

                // Credit Type Dropdown
                DropdownButtonFormField<CreditType>(
                  value: _selectedCreditType,
                  decoration: const InputDecoration(labelText: 'Tipo de Crédito'),
                  items: CreditType.values.map((creditType) {
                    return DropdownMenuItem(
                      value: creditType,
                      child: Text(creditType.name), // Display the enum name
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCreditType = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor seleccione un tipo de crédito';
                    }
                    return null;
                  },
                ),

                // Grace Period (conditionally visible for LONG_TERM credit)
                if (_selectedCreditType == CreditType.LONG_TERM)
                  TextFormField(
                    controller: _gracePeriodController,
                    decoration: const InputDecoration(
                        labelText: 'Período de Gracia (meses)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el período de gracia';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor ingrese un valor numérico válido';
                      }
                      return null;
                    },
                  ),

                // Late Fee Percentage
                TextFormField(
                  controller: _lateFeePercentageController,
                  decoration: const InputDecoration(
                      labelText: 'Porcentaje de Cargo por Mora (%)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el porcentaje de cargo por mora';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un valor numérico válido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addClient,
                  child: const Text('Agregar Cliente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}