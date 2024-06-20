import 'package:tf/models/establishment.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final String imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Establishment? establishment;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.establishment,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      stock: json['stock'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      establishment: json['establishment'] != null
          ? Establishment.fromJson(json['establishment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stock': stock,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'establishment': establishment?.toJson(),
    };
  }
}
