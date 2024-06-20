import 'package:tf/models/admin.dart';
import 'package:tf/models/product.dart';

class Establishment {
  final int id;
  final String ruc;
  final String name;
  final String phone;
  final String address;
  final String imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Admin? admin;
  final List<Product> products;

  Establishment({
    required this.id,
    required this.ruc,
    required this.name,
    required this.phone,
    required this.address,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.admin,
    required this.products,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      id: json['id'],
      ruc: json['ruc'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruc': ruc,
      'name': name,
      'phone': phone,
      'address': address,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'admin': admin?.toJson(),
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}