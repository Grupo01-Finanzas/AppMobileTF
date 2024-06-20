import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/models/establishment.dart';
import 'package:tf/services/establishment_service.dart';


class SearchEstablishmentsPage extends StatefulWidget {
  const SearchEstablishmentsPage({super.key});

  @override
  State<SearchEstablishmentsPage> createState() =>
      _SearchEstablishmentsPageState();
}

class _SearchEstablishmentsPageState
    extends State<SearchEstablishmentsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Establishment> _allEstablishments = [];
  List<Establishment> _filteredEstablishments = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadEstablishments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadEstablishments() async {
    final establishmentService = context.read<EstablishmentService>();
    final establishments = await establishmentService.getAllEstablishments();
    setState(() {
      _allEstablishments = establishments;
      _filteredEstablishments = establishments;
    });
  }

  void _filterEstablishments(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _filteredEstablishments = _allEstablishments
            .where((establishment) => establishment.name
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Establecimientos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterEstablishments,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEstablishments.length,
              itemBuilder: (context, index) {
                final establishment = _filteredEstablishments[index];
                return _buildEstablishmentCard(establishment);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstablishmentCard(Establishment establishment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          // Navegar a la vista de detalles del establecimiento
          // Puedes pasar el ID del establecimiento como argumento
          Navigator.of(context).pushNamed('/establishmentDetails',
              arguments: establishment.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                establishment.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text('RUC: ${establishment.ruc}'),
              Text('Teléfono: ${establishment.phone}'),
              Text('Dirección: ${establishment.address}'),
            ],
          ),
        ),
      ),
    );
  }
}