import 'dart:convert';
import 'package:http/http.dart' as http;
class InstallmentService {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> createInstallment(
      {required int creditAccountId,
      required String dueDate,
      required double amount,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/installments');
    final body = jsonEncode({
      'credit_account_id': creditAccountId,
      'due_date': dueDate,
      'amount': amount,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create installment: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getInstallmentById(
      {required int installmentId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/installments/$installmentId');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get installment by ID: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateInstallment(
      {required int installmentId,
      required String dueDate,
      required double amount,
      required String status,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/installments/$installmentId');
    final body = jsonEncode({
      'due_date': dueDate,
      'amount': amount,
      'status': status,
    });

    final response = await http.put(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update installment: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> deleteInstallment(
      {required int installmentId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/installments/$installmentId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 204) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete installment: ${response.statusCode}');
    }
  }
}

class PurchaseService {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> createPurchase(
      {required String accessToken,
      required int establishmentID,
      required List<int> productIds,
      required String creditType,
      required double amount}) async {
    final url = Uri.parse('$baseUrl/purchases');
    final body = jsonEncode({
      'establishment_id': establishmentID,
      'product_ids': productIds,
      'credit_type': creditType,
      'amount': amount,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create purchase: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getClientBalance(
      {required String accessToken}) async {
    final url = Uri.parse('$baseUrl/clients/me/balance');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get client balance: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getClientTransactions(
      {required String accessToken}) async {
    final url = Uri.parse('$baseUrl/clients/me/transactions');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get client transactions: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getClientOverdueBalance(
      {required String accessToken}) async {
    final url = Uri.parse('$baseUrl/clients/me/overdue-balance');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get client overdue balance: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getClientInstallments(
      {required String accessToken}) async {
    final url = Uri.parse('$baseUrl/clients/me/installments');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get client installments: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getClientCreditAccount(
      {required String accessToken}) async {
    final url = Uri.parse('$baseUrl/clients/me/credit-account');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get client credit account: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getClientAccountSummary(
      {required String accessToken}) async {
    final url = Uri.parse('$baseUrl/clients/me/account-summary');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get client account summary: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getClientAccountStatement(
      {required String accessToken,
      String? startDate,
      String? endDate}) async {
    final url = Uri.parse('$baseUrl/clients/me/account-statement');
    final queryParams = {
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
    final uri = url.replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get client account statement: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getClientAccountStatementPDF(
      {required String accessToken,
      String? startDate,
      String? endDate}) async {
    final url = Uri.parse('$baseUrl/clients/me/account-statement/pdf');
    final queryParams = {
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
    final uri = url.replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get client account statement PDF: ${response.statusCode}');
    }
  }
}