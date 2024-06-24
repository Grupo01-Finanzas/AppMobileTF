import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> registerAdmin({
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

   Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final loginData = jsonDecode(response.body);
      
      // Store tokens in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = await getUserIdByEmail(email, loginData['access_token']);
      print('userId: $userId');
      await prefs.setInt('userId', userId);
      await prefs.setString('accessToken', loginData['access_token']);
      await prefs.setString('refreshToken', loginData['refresh_token']);

      return loginData;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  } 

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
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

   Future<int> getUserIdByEmail(String email, String accessToken) async {
    final url = Uri.parse('$baseUrl/users/email-to-id?email=$email');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user_id'] as int;
    } else if (response.statusCode == 404) {
      throw Exception('User not found'); 
    } else {
      throw Exception('Failed to get user ID: ${response.statusCode}');
    }
  }

  Future<int> getUserIdFromToken(String token) async {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Ensure the token is valid
      if (decodedToken.containsKey('exp') && 
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000).isAfter(DateTime.now())) {

        // Extract and return the userId
        if (decodedToken.containsKey('userId') && decodedToken['userId'] is int) {
          return decodedToken['userId'];
        } else {
          throw Exception('Invalid token: userId not found or not an integer');
        }
      } else {
        throw Exception('Token has expired');
      }
    } catch (e) {
      throw Exception('Error decoding token: $e');
    }
  }
}