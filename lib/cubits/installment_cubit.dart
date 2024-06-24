// installment_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/installment_response.dart';
import 'package:tf/repository/installment_repository.dart'; 


part 'installment_state.dart';

class InstallmentCubit extends Cubit<InstallmentState> {
  final InstallmentRepository _installmentRepository;

  InstallmentCubit({required InstallmentRepository installmentRepository})
      : _installmentRepository = installmentRepository,
        super(InstallmentInitial());

  Future<void> fetchInstallments(int userId) async {
    emit(InstallmentLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken != null) {
        final installments = await _installmentRepository.getInstallments(userId, accessToken);
        emit(InstallmentLoaded(installments: installments));
      } else {
        emit(const InstallmentError(message: 'Access token not found')); 
      }
    } catch (e) {
      emit(InstallmentError(message: e.toString()));
    }
  }

}