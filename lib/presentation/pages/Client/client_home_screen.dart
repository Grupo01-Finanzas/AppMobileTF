import 'package:flutter/material.dart';
import 'package:tf/presentation/pages/Client/client_account_summary_screen.dart';
import 'package:tf/presentation/pages/Client/client_home_page.dart';
import 'package:tf/presentation/pages/Client/client_purchase_screen.dart';
import 'package:tf/presentation/pages/Principal/settings.page.dart';
import 'package:tf/presentation/widgets/client/bottom_nav_bar.dart';


class ClientHomeScreen extends StatefulWidget {
  final int establishmentId;
  final String baseUrl =
      'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  const ClientHomeScreen({super.key, required this.establishmentId});

  @override
  State<ClientHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<ClientHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const ClientHomePage(),
      const ClientPurchaseScreen(),
      const ClientAccountSummaryScreen(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
