import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/establishment.dart';
import 'package:tf/services/api/establishment_service.dart';
import 'package:http/http.dart' as http;


class EstablishmentRepository {
  final EstablishmentService _establishmentService;

  EstablishmentRepository({EstablishmentService? establishmentService})
      : _establishmentService = establishmentService ?? EstablishmentService();

  Future<Establishment?> getEstablishment(String accessToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId != null) {
        return await _establishmentService.getEstablishmentByAdminId(userId, accessToken);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching establishment: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateEstablishmentMap(
      {required String ruc,
      required String name,
      required String phone,
      required String address,
      required String imageUrl,
      required bool isActive,
      required String accessToken}) async {
    try {
      return await _establishmentService.updateEstablishment(
          ruc: ruc,
          name: name,
          phone: phone,
          address: address,
          imageUrl: imageUrl,
          isActive: isActive,
          accessToken: accessToken);
    } catch (e) {
      print('Error updating establishment: $e');
      rethrow;
    }
  }

  Future<Establishment?> updateEstablishment(
      int establishmentId, Establishment establishment, String accessToken) async {
    try {
      return await _establishmentService.updateEstablishmentU(
          establishmentId, establishment, accessToken);
    } catch (e) {
      print("Error updating establishment: $e");
      rethrow;
    }
  }

  // Add more repository methods as needed based on your EstablishmentService
  Future<Establishment?> getEstablishmentByAdminId(
      int adminId, String accessToken) async {
    try {
      return await _establishmentService.getEstablishmentByAdminId(
          adminId, accessToken);
    } catch (e) {
      print("Error getting establishment by admin ID: $e");
      rethrow;
    }
  }

   Future<Establishment> getEstablishmentById(int establishmentId, String accessToken) async {
    try {
      final url = Uri.parse('${_establishmentService.baseUrl}/establishments/$establishmentId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Establishment data: $data");
        return Establishment.fromJson(data);
      } else {
        throw Exception('Failed to load establishment: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching establishment by ID: $e");
      rethrow; 
    }
  }
}