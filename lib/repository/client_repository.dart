
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/user.dart';
import 'package:tf/services/api/user_service.dart';
import 'package:http/http.dart' as http;

class ClientRepository {
  final UserService _userService;

  ClientRepository({UserService? userService})
      : _userService = userService ?? UserService();

  Future<List<User>> getClientsByEstablishmentId(
      int establishmentId, String accessToken) async {
    try {
      final url = Uri.parse(
          '${_userService.baseUrl}/establishments/$establishmentId/clients');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        final clients = data.map((item) => User.fromJson(item)).toList();

        // Store the establishment ID in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('establishmentId', establishmentId);
        print('Establishment ID: $establishmentId');
        print('Clients: $clients');

        return clients; 
      } else {
        throw Exception(
            'Failed to get clients by establishment ID: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching clients by establishment ID: $e");
      rethrow;
    }
  }

   Future<void> createClient({
    required int clientId,
    required String dni,
    required String name,
    required String address,
    required String phone,
    required String email,
    required String password, 
    required double creditLimit,
    required int monthlyDueDate,
    required double interestRate,
    required String interestType, // Now a String
    required String creditType,   // Now a String
    required int gracePeriod,
    required double lateFeePercentage,
    required int establishmentId,
    required String accessToken,
  }) async {
    try {
      await _userService.createClient(
        dni: dni,
        name: name,
        address: address,
        phone: phone,
        creditLimit: creditLimit,
        monthlyDueDate: monthlyDueDate,
        interestRate: interestRate,
        interestType: interestType,
        creditType: creditType,
        accessToken: accessToken,
        establishmentID: establishmentId, email: email, lateFeePercentage: lateFeePercentage,
      );
    } catch (e) {
      print("Error creating client: $e");
      rethrow; 
    }
  }

  // Add other repository methods for managing clients (create, update, delete, etc.) as needed
}