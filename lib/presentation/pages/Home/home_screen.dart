import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tf/services/api/user_service.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the current user's information
    context
        .read<UserService>()
        .getCurrentUser(accessToken: widget.token)
        .then((currentUser) {
      // Check the role and navigate to the appropriate home screen
      print(currentUser);
      final role = currentUser['rol'];
      print(role);
      if (role == 'ADMIN') {
        final establishmentId = currentUser['establishment_id'].toString();
        // Navigate with the establishmentId
        context.go('/establishments/$establishmentId/admin'); 
      } else if (role == 'CLIENT') {
        context.go('/client');
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome! Loading...'),
      ),
    );
  }
}