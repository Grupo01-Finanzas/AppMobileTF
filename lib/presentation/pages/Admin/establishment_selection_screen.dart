import 'package:flutter/material.dart';
import 'package:tf/models/establishment.dart';


class EstablishmentSelectionScreen extends StatelessWidget {
  final List<Establishment> establishments;

  const EstablishmentSelectionScreen({super.key, required this.establishments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Establishment')),
      body: ListView.builder(
        itemCount: establishments.length,
        itemBuilder: (context, index) {
          final establishment = establishments[index];
          return ListTile(
            title: Text(establishment.name),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/adminHome',
                  arguments: establishment.id);
            },
          );
        },
      ),
    );
  }
}