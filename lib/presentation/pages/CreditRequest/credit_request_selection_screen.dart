import 'package:flutter/material.dart';
import 'package:tf/presentation/pages/CreditRequest/credit_request_form_screen.dart';


class CreditRequestSelectionScreen extends StatelessWidget {
  final Map<int, int> cartItems;

  const CreditRequestSelectionScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Tipo de Crédito')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToCreditRequestForm(context, 'SHORT_TERM'),
              child: const Text('Crédito a Corto Plazo'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _navigateToCreditRequestForm(context, 'LONG_TERM'),
              child: const Text('Crédito a Largo Plazo'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreditRequestForm(BuildContext context, String creditType) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CreditRequestFormScreen(creditType: creditType, cartItems: cartItems), // Pasa el tipo de crédito a la siguiente pantalla
    ));
  }
}