// services/api_service.dart
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tf/models/account_statement_response.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tf/models/user.dart';
import 'dart:convert';

import '../models/admin.dart';
import '../models/admin_debt_summary.dart';
import '../models/client.dart';
import '../models/client_balance_response.dart';
import '../models/credit_account.dart';
import '../models/credit_request.dart';
import '../models/establishment.dart';
import '../models/installment.dart';
import '../models/late_fee.dart';
import '../models/late_fee_rule.dart';
import '../models/product.dart';
import '../models/transaction.dart';

class ApiService {
  final String _baseUrl = 'http://your-api-base-url/api/v1';
  final EncryptedSharedPreferences _prefs =
      EncryptedSharedPreferences.getInstance();

  Future<String?> _getToken() async {
    return _prefs.getString('token');
  }

  Future<void> _setToken(String token) async {
    await _prefs.setString('token', token);
  }

  Future<void> _deleteToken() async {
    await _prefs.remove('token');
  }

  // Authentication Services
  Future<void> registerUser(
    String dni,
    String email,
    String password,
    String name,
    String address,
    String phone,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'dni': dni,
        'email': email,
        'password': password,
        'name': name,
        'address': address,
        'phone': phone,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      await _setToken(data['access_token']);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> refreshToken() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/refresh'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      await _setToken(data['access_token']);
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  Future<void> resetPassword(String currentPassword, String newPassword) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password: ${response.body}');
    }
  }

  Future<void> logout() async {
    await _deleteToken();
  }

  Future<User?> getCurrentUser() async {
    final token = await _getToken();
    if (token == null) {
      return null; // El usuario no está autenticado
    }

    // Decodifica el token para obtener el ID del usuario
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['user_id'] as int;

      // Llama a la API para obtener los datos del usuario
      final response = await http.get(Uri.parse('$_baseUrl/users/$userId'));

      if (response.statusCode == 200) {
        // Decodifica el cuerpo de la respuesta en un Map<String, dynamic>
        final Map<String, dynamic> userData = json.decode(response.body);
        return User.fromJson(userData);
      } else {
        throw Exception('Failed to get user: ${response.body}');
      }
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }

  // Admin Services

  Future<List<Admin>> getAllAdmins() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/admins'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Admin.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get admins: ${response.body}');
    }
  }

  Future<User?> getUserById(int userId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId'), // Convierte la ruta a Uri
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  Future<List<Establishment>> getEstablishmentsByAdminId(int adminId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/admins/$adminId/establishments'), // Convierte a Uri
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Establishment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get establishments: ${response.body}');
    }
  }

  Future<Admin> getAdminById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/admins/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Admin.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get admin: ${response.body}');
    }
  }

  Future<void> updateAdmin(int id, bool isActive) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/admins/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'is_active': isActive}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update admin: ${response.body}');
    }
  }

  Future<void> deleteAdmin(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/admins/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete admin: ${response.body}');
    }
  }

  Future<void> registerEstablishment(
    String ruc,
    String name,
    String phone,
    String address,
    String imageUrl,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/register-establishments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'ruc': ruc,
        'name': name,
        'phone': phone,
        'address': address,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register establishment: ${response.body}');
    }
  }

  // Client Services

  Future<List<Client>> getAllClients() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Client.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get clients: ${response.body}');
    }
  }

  Future<Client> getClientById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get client: ${response.body}');
    }
  }

  Future<void> updateClient(int id, bool isActive) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/clients/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'is_active': isActive}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update client: ${response.body}');
    }
  }

  Future<void> deleteClient(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/clients/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete client: ${response.body}');
    }
  }

  Future<List<Client>> getClientsByEstablishmentId(int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/establishments/$establishmentId/clients'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((clientJson) {
        final userJson = clientJson['user'];
        return Client(
          id: clientJson['id'],
          user: User.fromJson(userJson),
          isActive: clientJson['is_active'],
          createdAt: DateTime.parse(clientJson['created_at']),
          updatedAt: DateTime.parse(clientJson['updated_at']),
        );
      }).toList();
    } else {
      throw Exception(
          'Failed to get clients by establishment ID: ${response.body}');
    }
  }

  Future<List<CreditRequest>> getCreditRequestsByEstablishmentId(
      int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/establishments/$establishmentId/credit-requests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => CreditRequest.fromJson(e)).toList();
    } else {
      throw Exception(
          'Failed to get credit requests by establishment ID: ${response.body}');
    }
  }

  // Establishment Services

  Future<List<Establishment>> getAllEstablishments() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/establishments'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Establishment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get establishments: ${response.body}');
    }
  }

  Future<Establishment> getEstablishmentById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/establishments/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Establishment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get establishment: ${response.body}');
    }
  }

  Future<void> updateEstablishment(
    int id,
    String ruc,
    String name,
    String phone,
    String address,
    bool isActive,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/establishments/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'ruc': ruc,
        'name': name,
        'phone': phone,
        'address': address,
        'is_active': isActive,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update establishment: ${response.body}');
    }
  }

  Future<void> deleteEstablishment(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/establishments/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete establishment: ${response.body}');
    }
  }

  Future<void> registerProducts(
      int establishmentId, List<int> productIds) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/establishments/$establishmentId/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(productIds),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to register products: ${response.body}');
    }
  }

  Future<void> addClientToEstablishment(
      int establishmentId, int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/establishments/$establishmentId/clients/$clientId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception(
          'Failed to add client to establishment: ${response.body}');
    }
  }

  // Product Services

  Future<List<Product>> getAllProducts() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/products'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get products: ${response.body}');
    }
  }

  Future<Product> getProductById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get product: ${response.body}');
    }
  }

  Future<List<Product>> getProductsByEstablishmentId(
      int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/establishments/$establishmentId/products'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get products: ${response.body}');
    }
  }

  Future<void> createProduct(
    String name,
    String description,
    double price,
    String category,
    int stock,
    String imageUrl,
    bool isActive,
    int establishmentId,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'stock': stock,
        'image_url': imageUrl,
        'is_active': isActive,
        'establishment_id': establishmentId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<void> updateProduct(
    int id,
    String name,
    String description,
    double price,
    String category,
    int stock,
    bool isActive,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'stock': stock,
        'is_active': isActive,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  Future<void> deleteProduct(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.body}');
    }
  }

  // Credit Account Services

  Future<void> createCreditAccount({
    required int establishmentId,
    required int clientId,
    required double creditLimit,
    required int monthlyDueDate,
    required double interestRate,
    required String interestType,
    required String creditType,
    int gracePeriod = 0,
    int? lateFeeRuleId,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/credit-accounts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'establishment_id': establishmentId,
        'client_id': clientId,
        'credit_limit': creditLimit,
        'monthly_due_date': monthlyDueDate,
        'interest_rate': interestRate,
        'interest_type': interestType,
        'credit_type': creditType,
        'grace_period': gracePeriod,
        if (lateFeeRuleId != null) 'late_fee_rule_id': lateFeeRuleId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create credit account: ${response.body}');
    }
  }

  Future<CreditAccount> getCreditAccountById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/credit-accounts/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return CreditAccount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get credit account: ${response.body}');
    }
  }

  Future<void> updateCreditAccount(
    int id, {
    double? creditLimit,
    int? monthlyDueDate,
    double? interestRate,
    String? interestType,
    String? creditType,
    int? gracePeriod,
    bool? isBlocked,
    int? lateFeeRuleId,
    double? currentBalance,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/credit-accounts/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (creditLimit != null) 'credit_limit': creditLimit,
        if (monthlyDueDate != null) 'monthly_due_date': monthlyDueDate,
        if (interestRate != null) 'interest_rate': interestRate,
        if (interestType != null) 'interest_type': interestType,
        if (creditType != null) 'credit_type': creditType,
        if (gracePeriod != null) 'grace_period': gracePeriod,
        if (isBlocked != null) 'is_blocked': isBlocked,
        if (lateFeeRuleId != null) 'late_fee_rule_id': lateFeeRuleId,
        if (currentBalance != null) 'current_balance': currentBalance,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update credit account: ${response.body}');
    }
  }

  Future<void> deleteCreditAccount(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/credit-accounts/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete credit account: ${response.body}');
    }
  }

  Future<List<CreditAccount>> getCreditAccountsByEstablishmentId(
      int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/establishments/$establishmentId/credit-accounts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => CreditAccount.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get credit accounts: ${response.body}');
    }
  }

  Future<List<CreditAccount>> getCreditAccountsByClientId(int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients/$clientId/credit-accounts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => CreditAccount.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get credit accounts: ${response.body}');
    }
  }

  Future<CreditRequest> updateCreditRequestDueDate(
      int id, DateTime newDueDate) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/credit-requests/$id/due-date'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'due_date': newDueDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CreditRequest.fromJson(data);
    } else {
      throw Exception(
          'Failed to update credit request due date: ${response.body}');
    }
  }

  Future<List<CreditRequest>> getCreditRequestsByClientId(int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients/$clientId/credit-requests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => CreditRequest.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to get credit requests: ${response.body}');
    }
  }

  Future<void> applyInterestToAllAccounts(int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse(
          '$_baseUrl/establishments/$establishmentId/credit-accounts/apply-interest'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to apply interest to all accounts: ${response.body}');
    }
  }

  Future<void> applyLateFeesToAllAccounts(int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse(
          '$_baseUrl/establishments/$establishmentId/credit-accounts/apply-late-fees'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to apply late fees to all accounts: ${response.body}');
    }
  }

  Future<List<AdminDebtSummary>> getAdminDebtSummary(
      int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse(
          '$_baseUrl/establishments/$establishmentId/credit-accounts/debt-summary'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => AdminDebtSummary.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get admin debt summary: ${response.body}');
    }
  }

  Future<void> processPurchase(
      int creditAccountId, double amount, String description) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/credit-accounts/$creditAccountId/purchases'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'description': description,
        // Add other fields as needed
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to process purchase: ${response.body}');
    }
  }

  Future<void> processPayment(
      int creditAccountId, double amount, String description) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/credit-accounts/$creditAccountId/payments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'description': description,
        // Add other fields as needed
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to process payment: ${response.body}');
    }
  }

  Future<void> assignCreditAccountToClient(
      int creditAccountId, int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/credit-accounts/$creditAccountId/clients/$clientId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to assign credit account to client: ${response.body}');
    }
  }

  // Client Account Statement Services
  Future<List<AccountStatementResponse>> getClientAccountStatement(int clientId,
      {DateTime? startDate, DateTime? endDate}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    var uri =
        Uri.parse('$_baseUrl/credit-accounts/clients/$clientId/statement');

    if (startDate != null || endDate != null) {
      uri = uri.replace(queryParameters: {
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      });
    }

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => AccountStatementResponse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get client account statement');
    }
  }

  // Client Account History Services
  Future<AccountStatementResponse> getClientAccountHistory(int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/credit-accounts/clients/$clientId/history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return AccountStatementResponse.fromJson(data);
    } else {
      throw Exception('Failed to get client account history');
    }
  }

  // Credit Request Services
  Future<void> createCreditRequest(
    int clientId,
    int establishmentId,
    double requestedCreditLimit,
    int monthlyDueDate,
    String interestType,
    String creditType,
    int gracePeriod,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/credit-requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'client_id': clientId,
        'establishment_id': establishmentId,
        'requested_credit_limit': requestedCreditLimit,
        'monthly_due_date': monthlyDueDate,
        'interest_type': interestType,
        'credit_type': creditType,
        'grace_period': gracePeriod,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create credit request: ${response.body}');
    }
  }

  Future<CreditRequest> getCreditRequestById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/credit-requests/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return CreditRequest.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get credit request: ${response.body}');
    }
  }

  Future<void> approveCreditRequest(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/credit-requests/$id/approve'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve credit request: ${response.body}');
    }
  }

  Future<void> rejectCreditRequest(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/credit-requests/$id/reject'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject credit request: ${response.body}');
    }
  }

  Future<List<CreditRequest>> getPendingCreditRequestsByEstablishmentId(
      int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse(
          '$_baseUrl/establishments/$establishmentId/credit-requests/pending'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => CreditRequest.fromJson(e)).toList();
    } else {
      throw Exception(
          'Failed to get pending credit requests: ${response.body}');
    }
  }

  // Transaction Services
  Future<void> createTransaction(int creditAccountId, String transactionType,
      double amount, String recipientType, int recipientId,
      {String? description}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/transactions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'credit_account_id': creditAccountId,
        'transaction_type': transactionType,
        'amount': amount,
        'recipient_type': recipientType,
        'recipient_id': recipientId,
        if (description != null) 'description': description,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create transaction: ${response.body}');
    }
  }

  Future<Transaction> getTransactionById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/transactions/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get transaction: ${response.body}');
    }
  }

  Future<void> updateTransaction(int id,
      {double? amount, String? description, String? transactionType}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/transactions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (amount != null) 'amount': amount,
        if (description != null) 'description': description,
        if (transactionType != null) 'transaction_type': transactionType,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update transaction: ${response.body}');
    }
  }

  Future<void> deleteTransaction(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/transactions/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete transaction: ${response.body}');
    }
  }

  Future<List<Transaction>> getTransactionsByCreditAccountId(
      int creditAccountId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/credit-accounts/$creditAccountId/transactions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Transaction.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get transactions: ${response.body}');
    }
  }

  // Purchase Services
  Future<void> createPurchase(
    int establishmentId,
    List<int> productIds,
    String creditType,
    double amount,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/purchases'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'establishment_id': establishmentId,
        'product_ids': productIds,
        'credit_type': creditType,
        'amount': amount,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create purchase: ${response.body}');
    }
  }

  Future<ClientBalanceResponse> getClientBalance(int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients/$clientId/balance'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ClientBalanceResponse.fromJson(data);
    } else {
      throw Exception('Failed to get client balance: ${response.body}');
    }
  }

  Future<List<Transaction>> getClientTransactions(int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients/$clientId/transactions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Transaction.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get client transactions: ${response.body}');
    }
  }

  Future<double> getClientOverdueBalance(int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients/$clientId/overdue-balance'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['overdue_balance'].toDouble();
    } else {
      throw Exception('Failed to get client overdue balance: ${response.body}');
    }
  }

  Future<List<Installment>> getClientInstallments(int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients/$clientId/installments'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Installment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get client installments: ${response.body}');
    }
  }

  Future<CreditAccount> getClientCreditAccount(int clientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/clients/$clientId/credit-account'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return CreditAccount.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get client credit account: ${response.body}');
    }
  }

  // Late Fee Services

  Future<void> createLateFee(int creditAccountId, double amount) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/late-fees'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'credit_account_id': creditAccountId,
        'amount': amount,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create late fee: ${response.body}');
    }
  }

  Future<LateFee> getLateFeeById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/late-fees/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return LateFee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get late fee: ${response.body}');
    }
  }

  Future<void> updateLateFee(int id, double amount) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/late-fees/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update late fee: ${response.body}');
    }
  }

  Future<void> deleteLateFee(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/late-fees/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete late fee: ${response.body}');
    }
  }

  Future<List<LateFee>> getLateFeesByCreditAccountId(
      int creditAccountId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/credit-accounts/$creditAccountId/late-fees'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => LateFee.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get late fees: ${response.body}');
    }
  }

  // Late Fee Rule Services

  Future<void> createLateFeeRule({
    int? establishmentId,
    required String name,
    required int daysOverdueMin,
    required int daysOverdueMax,
    required String feeType,
    required double feeValue,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/late-fee-rules'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (establishmentId != null) 'establishment_id': establishmentId,
        'name': name,
        'days_overdue_min': daysOverdueMin,
        'days_overdue_max': daysOverdueMax,
        'fee_type': feeType,
        'fee_value': feeValue,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create late fee rule: ${response.body}');
    }
  }

  Future<LateFeeRule> getLateFeeRuleById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/late-fee-rules/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return LateFeeRule.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get late fee rule: ${response.body}');
    }
  }

  Future<void> updateLateFeeRule(int id,
      {String? name,
      int? daysOverdueMin,
      int? daysOverdueMax,
      String? feeType,
      double? feeValue}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/late-fee-rules/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (daysOverdueMin != null) 'days_overdue_min': daysOverdueMin,
        if (daysOverdueMax != null) 'days_overdue_max': daysOverdueMax,
        if (feeType != null) 'fee_type': feeType,
        if (feeValue != null) 'fee_value': feeValue,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update late fee rule: ${response.body}');
    }
  }

  Future<void> deleteLateFeeRule(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/late-fee-rules/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete late fee rule: ${response.body}');
    }
  }

  Future<List<LateFeeRule>> getAllLateFeeRules() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/late-fee-rules'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => LateFeeRule.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get late fee rules: ${response.body}');
    }
  }

  Future<List<LateFeeRule>> getLateFeeRulesByEstablishmentId(
      int establishmentId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/establishments/$establishmentId/late-fee-rules'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => LateFeeRule.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get late fee rules: ${response.body}');
    }
  }

  // Installment Services

  Future<void> createInstallment(int creditAccountId, DateTime dueDate,
      double amount, String status) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/installments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'credit_account_id': creditAccountId,
        'due_date': dueDate.toIso8601String(),
        'amount': amount,
        'status': status,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create installment: ${response.body}');
    }
  }

  Future<Installment> getInstallmentById(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/installments/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Installment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get installment: ${response.body}');
    }
  }

  Future<void> updateInstallment(int id,
      {DateTime? dueDate, double? amount, String? status}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/installments/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (dueDate != null) 'due_date': dueDate.toIso8601String(),
        if (amount != null) 'amount': amount,
        if (status != null) 'status': status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update installment: ${response.body}');
    }
  }

  Future<void> deleteInstallment(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/installments/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete installment: ${response.body}');
    }
  }

  Future<List<Installment>> getInstallmentsByCreditAccountId(
      int creditAccountId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/credit-accounts/$creditAccountId/installments'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Installment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get installments: ${response.body}');
    }
  }

  Future<List<Installment>> getOverdueInstallmentsByCreditAccountId(
      int creditAccountId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse(
          '$_baseUrl/credit-accounts/$creditAccountId/installments/overdue'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Installment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get overdue installments: ${response.body}');
    }
  }
}
