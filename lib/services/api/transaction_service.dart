import 'dart:convert';
import 'package:http/http.dart' as http;
class TransactionService {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> createTransaction(
      {required int creditAccountId,
      required String transactionType,
      required double amount,
      required String description,
      required String paymentMethod,
      required String confirmationCode,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/transactions');
    final body = jsonEncode({
      'credit_account_id': creditAccountId,
      'transaction_type': transactionType,
      'amount': amount,
      'description': description,
      'payment_method': paymentMethod,
      'confirmation_code': confirmationCode,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create transaction: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getTransactionById(
      {required int transactionId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/transactions/$transactionId');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get transaction by ID: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateTransaction(
      {required int transactionId,
      required double amount,
      required String description,
      required String transactionType,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/transactions/$transactionId');
    final body = jsonEncode({
      'amount': amount,
      'description': description,
      'transaction_type': transactionType,
    });

    final response = await http.put(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update transaction: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> deleteTransaction(
      {required int transactionId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/transactions/$transactionId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 204) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete transaction: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> confirmPayment(
      {required int transactionId,
      required String confirmationCode,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/transactions/$transactionId/confirm');
    final body = jsonEncode({'confirmation_code': confirmationCode});

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to confirm payment: ${response.statusCode}');
    }
  }
}