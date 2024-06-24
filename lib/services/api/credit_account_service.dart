import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf/models/api/admin_debt_summary.dart';
import 'package:tf/models/api/credit_account.dart';

class CreditAccountService {
  final String baseUrl = 'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> createCreditAccount(
      {required int clientID,
      required double creditLimit,
      required int monthlyDueDate,
      required double interestRate,
      required String interestType,
      required String creditType,
      required String accessToken,
      required int establishmentID}) async {
    final url = Uri.parse('$baseUrl/credit-accounts');
    final body = jsonEncode({
      'client_id': clientID,
      'credit_limit': creditLimit,
      'monthly_due_date': monthlyDueDate,
      'interest_rate': interestRate,
      'interest_type': interestType,
      'credit_type': creditType,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create credit account: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCreditAccountById(
      {required int creditAccountId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/credit-accounts/$creditAccountId');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get credit account by ID: ${response.statusCode}');
    }
  }

  Future<List<AdminDebtSummary>> getAdminDebtSummary(
      int establishmentId, String accessToken) async {
    final url = Uri.parse('$baseUrl/credit-accounts/debt-summary');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((item) => AdminDebtSummary.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
          'Failed to get admin debt summary: ${response.statusCode}');
    }
  }


  Future<Map<String, dynamic>> updateCreditAccount(
      {required int creditAccountId,
      required double creditLimit,
      required int monthlyDueDate,
      required double interestRate,
      required String interestType,
      required String creditType,
      required bool isBlocked,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/credit-accounts/$creditAccountId');
    final body = jsonEncode({
      'credit_limit': creditLimit,
      'monthly_due_date': monthlyDueDate,
      'interest_rate': interestRate,
      'interest_type': interestType,
      'credit_type': creditType,
      'is_blocked': isBlocked,
    });

    final response = await http.put(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update credit account: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> deleteCreditAccount(
      {required int creditAccountId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/credit-accounts/$creditAccountId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 204) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete credit account: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> applyInterestToAccount(
      {required int creditAccountId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/credit-accounts/$creditAccountId/apply-interest');

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to apply interest to credit account: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> applyLateFeeToAccount(
      {required int creditAccountId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/credit-accounts/$creditAccountId/apply-late-fee');

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to apply late fee to credit account: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getOverdueCreditAccounts(
      {required String accessToken}) async {
    final url = Uri.parse('$baseUrl/credit-accounts/overdue');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to get overdue credit accounts: ${response.statusCode}');
    }
  }

  Future<CreditAccount?> getCreditAccountByClientId(
      int clientId, String accessToken) async {
    final url = Uri.parse('$baseUrl/clients/$clientId/credit-account');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null) {
        return CreditAccount.fromJson(data);
      } else {
        return null;
      }
    } else {
      throw Exception(
          'Failed to get credit account by client ID: ${response.statusCode}');
    }
  }
}

