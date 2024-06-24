import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // Inicio
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), // Compra
          label: 'Purchase',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance), // Resumen de cuenta
          label: 'Cuenta',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings), // Configuración
          label: 'Configuración',
        ),
      ],
    );
  }
}
