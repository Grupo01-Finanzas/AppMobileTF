import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/cubits/establishment_cubit.dart';
import 'package:tf/repository/establishment_repository.dart';


class EstablishmentScreen extends StatefulWidget {
  final int establishmentId;

  const EstablishmentScreen({super.key, required this.establishmentId});

  @override
  EstablishmentScreenState createState() => EstablishmentScreenState();
}

class EstablishmentScreenState extends State<EstablishmentScreen> {
  // Fetch the access token (you might need to adjust this based on your implementation)
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _fetchAccessToken();
  }

  Future<void> _fetchAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _accessToken = prefs.getString('accessToken'); 
  });
}

  @override
  Widget build(BuildContext context) {
    if (_accessToken == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider(
      create: (context) => EstablishmentCubit(
          establishmentRepository: context.read<EstablishmentRepository>())
        ..fetchEstablishmentById(widget.establishmentId, _accessToken!),
      child: Scaffold(
        appBar: AppBar(title: const Text('Establishment Details')),
        body: BlocBuilder<EstablishmentCubit, EstablishmentState>(
          builder: (context, state) {
            if (state is EstablishmentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EstablishmentLoaded) {
              final establishment = state.establishment;
              return Center(
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Name: ${establishment.name}'),
                    Text('RUC: ${establishment.ruc}'),
                    Text('Address: ${establishment.address}'),
                    Text('Phone: ${establishment.phone}')
                  ],
                ),
              );
            } else if (state is EstablishmentError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox
                  .shrink();
            }
          },
        ),
      ),
    );
  }
}