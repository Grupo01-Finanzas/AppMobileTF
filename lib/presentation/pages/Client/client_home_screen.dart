import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/cubits/auth_cubit.dart';
import 'package:tf/presentation/pages/Client/client_account_summary_screen.dart';
import 'package:tf/presentation/pages/Client/client_home_page.dart';
import 'package:tf/presentation/pages/Client/client_purchase_screen.dart';
import 'package:tf/presentation/pages/Principal/settings.page.dart';
import 'package:tf/presentation/widgets/client/bottom_nav_bar.dart';
import 'package:tf/presentation/widgets/client/floating_change_password_dialog.dart';
import 'package:tf/services/api/user_service.dart';

class ClientHomeScreen extends StatefulWidget {
  final Map<String, dynamic> token;

  const ClientHomeScreen({super.key, required this.token});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ClientHomePage(),
    const ClientPurchaseScreen(),
    const ClientAccountSummaryScreen(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {

    final needsPasswordUpdate = context.read<AuthCubit>().state is AuthLoginSuccess &&
        context.read<UserService>().needsPasswordUpdate(widget.token); 

    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          if (needsPasswordUpdate) FloatingChangePasswordDialog(
            onPasswordUpdated: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contraseña actualizada correctamente')),
              );
            },
          ),
        ],
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