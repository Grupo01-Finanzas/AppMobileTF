import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tf/models/api/establishment.dart';
import 'package:tf/repository/establishment_repository.dart';


part 'establishment_state.dart';

class EstablishmentCubit extends Cubit<EstablishmentState> {
  final EstablishmentRepository establishmentRepository;

  EstablishmentCubit({required this.establishmentRepository}) : super(EstablishmentInitial());

  Future<void> fetchEstablishment(int establishmentId, String accessToken) async {
    emit(EstablishmentLoading());
    try {
      final establishment = await establishmentRepository.getEstablishmentById(establishmentId, accessToken);
      emit(EstablishmentLoaded(establishment: establishment));
    } catch (e) {
      emit(EstablishmentError(message: e.toString()));
    }
  }

  Future<void> fetchEstablishmentById(int establishmentId, String accessToken) async {
    emit(EstablishmentLoading());
    try {
      final establishment = await establishmentRepository.getEstablishmentById(
          establishmentId, accessToken);
      emit(EstablishmentLoaded(establishment: establishment));
    } catch (e) {
      emit(EstablishmentError(message: e.toString()));
    }
  }
}