import 'package:flutter/material.dart';
import 'package:tf/presentation/pages/Admin/admin_debt_summary_page.dart';
import 'package:tf/presentation/pages/Admin/admin_home_page.dart';
import 'package:tf/presentation/pages/Admin/admin_products_page.dart';
import 'package:tf/presentation/pages/Admin/admin_settings_page.dart';


class AdminHomeScreen extends StatefulWidget {
  final int establishmentId;

  const AdminHomeScreen({super.key, required this.establishmentId});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AdminHomePage(),
    AdminDebtSummaryPage(),
    AdminProductsPage(),
    AdminSettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize),
            label: 'Deudas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}