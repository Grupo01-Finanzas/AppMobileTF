import 'package:tf/models/user.dart';

import 'api_service.dart';

class AuthenticationService {
  final ApiService _apiService;

  AuthenticationService(this._apiService);

  Future<void> registerUser(
    String dni,
    String email,
    String password,
    String name,
    String address,
    String phone,
  ) async {
    await _apiService.registerUser(dni, email, password, name, address, phone);
  }

  Future<void> loginUser(String email, String password) async {
    await _apiService.loginUser(email, password);
  }

  Future<void> refreshToken() async {
    await _apiService.refreshToken();
  }

  Future<void> resetPassword(String currentPassword, String newPassword) async {
    await _apiService.resetPassword(currentPassword, newPassword);
  }

  Future<void> logout() async {
    await _apiService.logout();
  }

  Future<User?> getCurrentUser() async {
    return await _apiService.getCurrentUser();
  }

  
}