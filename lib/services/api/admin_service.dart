import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminService {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> getAdminProfile(
      {required String accessToken}) async {
    final url = Uri.parse('$baseUrl/admins/me');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get admin profile: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateAdminProfile(
      {required String name,
      required String address,
      required String phone,
      required String photoUrl,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/admins/me');
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
      throw Exception('Failed to update admin profile: ${response.statusCode}');
    }
  }
}
