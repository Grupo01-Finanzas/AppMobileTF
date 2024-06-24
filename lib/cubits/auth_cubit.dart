import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> registerAdmin({
    required String dni,
    required String email,
    required String password,
    required String name,
    required String address,
    required String phone,
    required String establishmentRuc,
    required String establishmentName,
    required String establishmentPhone,
    required String establishmentAddress,
  }) async {
    emit(AuthRegisterLoading());
    try {
      await authRepository.registerAdmin(
        dni: dni,
        email: email,
        password: password,
        name: name,
        address: address,
        phone: phone,
        establishmentRuc: establishmentRuc,
        establishmentName: establishmentName,
        establishmentPhone: establishmentPhone,
        establishmentAddress: establishmentAddress,
      );

      emit(AuthRegisterSuccess());
    } catch (error) {
      emit(AuthRegisterFailure(error: error.toString()));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoginLoading());
    try {
      final response = await authRepository.login(email: email, password: password);
      final userId = await authRepository.getUserIdByEmail(email, response['access_token']);
      print(userId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
      emit(AuthLoginSuccess(token: response));
    } catch (error) {
      emit(AuthLoginFailure(error: error.toString()));
      print(error.toString());
    }
  }

  Future<void> refreshToken({
    required String refreshToken,
  }) async {
    emit(AuthRefreshTokenLoading());
    try {
      final response = await authRepository.refreshToken(refreshToken: refreshToken);
      emit(AuthRefreshTokenSuccess(token: response));
    } catch (error) {
      emit(AuthRefreshTokenFailure(error: error.toString()));
      print(error.toString());
    }
  }
}