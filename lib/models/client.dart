import 'package:tf/models/user.dart';

class Client {
  final int id;
  final User? user;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Client({
    required this.id,
    this.user,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}