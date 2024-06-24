import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> registerAdmin(
      {required String dni,
      required String email,
      required String password,
      required String name,
      required String address,
      required String phone,
      required String establishmentRuc,
      required String establishmentName,
      required String establishmentPhone,
      required String establishmentAddress}) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode({
      'dni': dni,
      'email': email,
      'password': password,
      'name': name,
      'address': address,
      'phone': phone,
      'establishment_ruc': establishmentRuc,
      'establishment_name': establishmentName,
      'establishment_phone': establishmentPhone,
      'establishment_address': establishmentAddress,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register admin: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> refreshToken(
      {required String refreshToken}) async {
    final url = Uri.parse('$baseUrl/refresh');
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $refreshToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to refresh token: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      {required String currentPassword,
      required String newPassword,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/reset-password');
    final body = jsonEncode({'current_password': currentPassword, 'new_password': newPassword});

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to reset password: ${response.statusCode}');
    }
  }
}


