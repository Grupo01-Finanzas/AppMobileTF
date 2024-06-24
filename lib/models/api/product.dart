

import 'package:tf/models/api/establishment.dart';

class Product {
  int id;
  int establishmentID;
  Establishment establishment;
  String name;
  String description;
  String category;
  double price;
  int stock;
  String imageUrl;
  bool isActive;

  Product({
    required this.id,
    required this.establishmentID,
    required this.establishment,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      establishmentID: json['establishment_id'],
      establishment: Establishment.fromJson(json['establishment']),
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
      stock: json['stock'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
    );
  }
}
