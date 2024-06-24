import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf/models/api/product.dart';

class ProductService {
  final String baseUrl =
      'https://si642-2401-ss82-group1-tf-production.up.railway.app/api/v1';

  Future<Map<String, dynamic>> createProduct(
      {required String name,
      required String category,
      required String description,
      required double price,
      required int stock,
      required String? imageUrl,
      required bool? isActive,
      required int establishmentID,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/products');
    final body = jsonEncode({
      'establishment_id': establishmentID,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'is_active': isActive,
    });

    final response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create product: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getProductById(
      {required int productId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/products/$productId');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get product by ID: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateProduct(
      {required int productId,
      required String name,
      required String category,
      required String description,
      required double price,
      required int stock,
      required String imageUrl,
      required bool isActive,
      required String accessToken}) async {
    final url = Uri.parse('$baseUrl/products/$productId');
    final body = jsonEncode({
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'stock': stock,
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
      throw Exception('Failed to update product: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> deleteProduct(
      {required int productId, required String accessToken}) async {
    final url = Uri.parse('$baseUrl/products/$productId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 204) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }

  Future<List<Product>> getProductsByEstablishmentId(
      int establishmentId, String accessToken) async {
    final url = Uri.parse('$baseUrl/establishments/$establishmentId/products');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data =
          jsonDecode(response.body) as List<dynamic>; // Explicit cast here

      // No need for null or empty checks after casting
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to get products by establishment ID: ${response.statusCode}');
    }
  }
}
