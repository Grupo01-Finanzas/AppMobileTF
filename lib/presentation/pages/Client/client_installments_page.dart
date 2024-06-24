import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/cubits/installment_cubit.dart';
import 'package:tf/repository/installment_repository.dart';

class ClientInstallmentsPage extends StatelessWidget {
  const ClientInstallmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InstallmentCubit(installmentRepository: context.read<InstallmentRepository>()),
      child: const ClientInstallmentsView(),
    );
  }
}

class ClientInstallmentsView extends StatefulWidget {
  const ClientInstallmentsView({super.key});

  @override
  State<ClientInstallmentsView> createState() => _ClientInstallmentsViewState();
}

class _ClientInstallmentsViewState extends State<ClientInstallmentsView> {
  @override
  void initState() {
    super.initState();
    _fetchInstallments();
  }

  Future<void> _fetchInstallments() async {
    final installmentCubit = context.read<InstallmentCubit>();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userId = prefs.getInt('userId');

    if (accessToken != null && userId != null) {
      installmentCubit.fetchInstallments(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Cuotas')),
      body: BlocBuilder<InstallmentCubit, InstallmentState>(
        builder: (context, state) {
          if (state is InstallmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InstallmentLoaded) {
            return ListView.builder(
              itemCount: state.installments.length,
              itemBuilder: (context, index) {
                final installment = state.installments[index];
                return Card(
                  child: ListTile(
                    title: Text('Cuota ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha de Vencimiento: ${installment.dueDate}'),
                        Text('Monto: S/ ${installment.amount}'),
                        Text('Estado: ${installment.status}'),
                        
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is InstallmentError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}