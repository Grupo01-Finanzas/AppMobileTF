// client_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/enum/credit_type.dart';
import 'package:tf/enum/interest_type.dart';
import 'package:tf/models/api/user.dart';
import 'package:tf/repository/client_repository.dart';

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  final ClientRepository _clientRepository;

  ClientCubit({required ClientRepository clientRepository})
      : _clientRepository = clientRepository,
        super(ClientInitial());

  Future<void> fetchClients() async {
    emit(ClientLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final establishmentId = prefs.getInt('establishmentId');

      if (accessToken != null && establishmentId != null) {
        final clients = await _clientRepository.getClientsByEstablishmentId(
            establishmentId, accessToken);
        emit(ClientLoaded(clients: clients));
      } else {
        emit(const ClientError(
            message: 'Access token or establishment ID not found'));
      }
    } catch (e) {
      emit(ClientError(message: e.toString()));
    }
  }

  Future<void> createClient({
    required String dni,
    required String name,
    required String address,
    required String phone,
    required String email,
    required String password,
    required double creditLimit,
    required int monthlyDueDate,
    required double interestRate,
    required InterestType interestType,
    required CreditType creditType,
    required int gracePeriod,
    required double lateFeePercentage,
    required int establishmentId,
    required String accessToken,
  }) async {
    emit(ClientLoading());
    try {
      await _clientRepository.createClient(
        dni: dni,
        name: name,
        address: address,
        phone: phone,
        email: email,
        password: password,
        creditLimit: creditLimit,
        monthlyDueDate: monthlyDueDate,
        interestRate: interestRate,
        interestType: interestType.name, // Convert enum to string
        creditType: creditType.name,       // Convert enum to string
        gracePeriod: gracePeriod,
        lateFeePercentage: lateFeePercentage,
        establishmentId: establishmentId,
        accessToken: accessToken,
      );
      emit(ClientCreated());
    } catch (e) {
      emit(ClientError(message: e.toString()));
    }
  }

}