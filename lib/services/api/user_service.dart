import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/user.dart';

class UserService {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> createClient(
      {
       required String dni,
       double gracePeriod = 0.0,
      required String name,
      required String address,
      required String email,
      required String phone,
      required double creditLimit,
      required int monthlyDueDate,
      required double interestRate,
      required String interestType,
      required double lateFeePercentage,
      required String creditType,
      required String accessToken,
      required int establishmentID}) async {
    final url = Uri.parse('$baseUrl/clients');
    final body = jsonEncode({
      'establishment_id': establishmentID,
      'dni': dni,
      'name': name,
      'address': address,
      'email': email,
      'phone': phone,
      'late_fee_percentage': lateFeePercentage,
      'credit_limit': creditLimit,
      'monthly_due_date': monthlyDueDate,
      'interest_rate': interestRate,
      'interest_type': interestType,
      'credit_type': creditType,
      'grace_period': gracePeriod,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 201) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create client: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getUserById(
      {required int userId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/users/$userId');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user by ID: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updatePassword({
    required int userId,
    required String newPassword,
    required String accessToken,
  }) async {
    final url = Uri.parse('$baseUrl/clients/me/password'); // Update to the correct endpoint

    final body = jsonEncode({
      'new_password': newPassword,
    });

    final response = await http.put(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update password: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> deleteUser(
      {required int userId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/users/$userId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 204) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateUser(
      {required int userId,
      required String name,
      required String address,
      required String phone,
      required String photoUrl,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final body = jsonEncode({
      'name': name,
      'address': address,
      'phone': phone,
      'photo_url': photoUrl,
    });

    final response = await http.put(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser({required String accessToken}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      throw Exception('User ID not found in shared preferences.');
    }

    final url = Uri.parse('$baseUrl/users/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get current user: ${response.statusCode}');
    }
  }

   Future<int> getUserIdByEmail(String email, String accessToken) async {
    final url = Uri.parse('$baseUrl/users/email-to-id?email=$email');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['user_id'] is int) {
        return data['user_id'] as int;
      } else {
        throw Exception('Invalid user ID format in response');
      }
    } else {
      throw Exception('Failed to get user ID: ${response.statusCode}');
    }
  }


  bool needsPasswordUpdate(Map<String, dynamic> token) {
    final user = User.fromJson(token['user']);
    return user.dni == user.password;
  }

  Future<User?> getUserByIdU(int userId, String accessToken) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data); // Convert to your API User model
    } else {
      throw Exception('Failed to get user: ${response.statusCode}');
    }
  }
}




