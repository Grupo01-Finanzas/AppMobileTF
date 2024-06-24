import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf/models/api/establishment.dart';

class EstablishmentService {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';


  Future<Map<String, dynamic>> updateEstablishment(
      {required String ruc,
      required String name,
      required String phone,
      required String address,
      required String imageUrl,
      required bool isActive,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/establishments/me');
    final body = jsonEncode({
      'ruc': ruc,
      'name': name,
      'phone': phone,
      'address': address,
      'image_url': imageUrl,
      'is_active': isActive,
    });

    final response = await http.put(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update establishment: ${response.statusCode}');
    }
  }

  Future<Establishment?> getEstablishmentByAdminId(
      int adminId, String accessToken) async {
    final url = Uri.parse('$baseUrl/admins/me');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['establishment'] != null && data['user']['id'] == adminId) {
        final establishment = data['establishment'];
        return Establishment.fromJson(establishment);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get establishment: ${response.statusCode}');
    }
  }


  Future<Establishment?> updateEstablishmentU(
      int establishmentId, Establishment establishment, String accessToken) async {
    final url = Uri.parse('$baseUrl/establishments/$establishmentId');
    final response = await http.put(url,
        body: jsonEncode(establishment.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Establishment.fromJson(data);
    } else {
      throw Exception('Failed to update establishment: ${response.statusCode}');
    }
  }
}


