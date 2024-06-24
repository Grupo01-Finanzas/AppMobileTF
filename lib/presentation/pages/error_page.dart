import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Error: $message'),
      ElevatedButton(
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
          child: const Text('Go Back')),
    ])));
  }
}
