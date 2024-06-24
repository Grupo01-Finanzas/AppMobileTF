import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tf/cubits/client_cubit.dart';
import 'package:tf/repository/client_repository.dart';


class ManageClientsPage extends StatelessWidget {
  
  final int establishmentId;

  const ManageClientsPage({super.key, required this.establishmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientCubit(clientRepository: context.read<ClientRepository>()),
      child: ManageClientsView(establishmentId: establishmentId,), 
    );
  }
}

class ManageClientsView extends StatefulWidget {
  final int establishmentId;
  const ManageClientsView({super.key, required this.establishmentId});

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
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                ElevatedButton(
                  onPressed: _fetchClients,
                  child: const Text('Retry'),
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/home');
                  }, 
                  child: const Text('Go Back')
                ),

              ]));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/establishments/${widget.establishmentId}/manageClients/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}