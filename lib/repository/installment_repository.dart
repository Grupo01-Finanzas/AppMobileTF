import 'dart:convert';

import 'package:tf/models/api/installment_response.dart'; 
import 'package:tf/services/api/installment_service.dart';
import 'package:http/http.dart' as http; 

class InstallmentRepository {
  final InstallmentService _installmentService;

  InstallmentRepository({InstallmentService? installmentService})
      : _installmentService = installmentService ?? InstallmentService(); 

  Future<List<InstallmentResponse>> getInstallments(int userId, String accessToken) async {
    try {
      final url = Uri.parse('${_installmentService.baseUrl}/clients/$userId/installments'); // Assuming your endpoint for installments 
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>; 
        return data.map((item) => InstallmentResponse.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to get installments: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching installments: $e"); 
      rethrow;
    }
  }

}