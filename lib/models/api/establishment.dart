

import 'package:tf/models/api/user.dart';

class Establishment {
  int id;
  String ruc;
  String name;
  String phone;
  String address;
  String imageUrl;
  User? admin;
  int lateFeePercentage;
  bool isActive;

  Establishment({
    required this.id,
    required this.ruc,
    required this.name,
    required this.phone,
    required this.address,
    required this.imageUrl,
    required this.admin,
    required this.lateFeePercentage,
    required this.isActive,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      id: json['id'],
      ruc: json['ruc'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      imageUrl: json['image_url'],
      admin: User.fromJson(json['admin'] ?? {}),
      lateFeePercentage: json['late_fee_percentage'],
      isActive: json['is_active'],
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
      'admin': admin!.toJson(),
      'late_fee_percentage': lateFeePercentage,
      'is_active': isActive,
    };
  }
}
