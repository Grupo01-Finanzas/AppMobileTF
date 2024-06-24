import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tf/cubits/client_cubit.dart';
import 'package:tf/repository/client_repository.dart';


class ManageClientsPage extends StatelessWidget {
  const ManageClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientCubit(clientRepository: context.read<ClientRepository>()),
      child: const ManageClientsView(), 
    );
  }
}

class ManageClientsView extends StatefulWidget {
  const ManageClientsView({super.key});

  @override
  State<ManageClientsView> createState() => _ManageClientsViewState();
}

class _ManageClientsViewState extends State<ManageClientsView> {
  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    context.read<ClientCubit>().fetchClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Clients'),
      ),
      body: BlocBuilder<ClientCubit, ClientState>(
        builder: (context, state) {
          if (state is ClientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClientLoaded) {
            return ListView.builder(
              itemCount: state.clients.length,
              itemBuilder: (context, index) {
                final client = state.clients[index];
                return ListTile(
                  title: Text(client.name ?? 'No name'), 
                  subtitle: Text(client.email ?? 'No email'),

                );
              },
            );
          } else if (state is ClientError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/manageClients/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}