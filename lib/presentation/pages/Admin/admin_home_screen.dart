import 'package:flutter/material.dart';
import 'package:tf/presentation/pages/Admin/admin_debt_summary_page.dart';
import 'package:tf/presentation/pages/Admin/admin_home_page.dart';
import 'package:tf/presentation/pages/Admin/admin_products_page.dart';
import 'package:tf/presentation/pages/Admin/admin_settings_page.dart';

class AdminHomeScreen extends StatefulWidget {
  final int establishmentId;
  final String baseUrl =
      'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  const AdminHomeScreen({super.key, required this.establishmentId});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      AdminHomePage(establishmentId: widget.establishmentId),
      const AdminDebtSummaryPage(),
      const AdminProductsPage(),
      const AdminSettingsPage(),
    ];
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
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
