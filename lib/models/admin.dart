import 'package:tf/models/establishment.dart';
import 'package:tf/models/user.dart';

class Admin {
  final int id;
  final int userId;
  final int establishmentId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Establishment? establishment;
  final User? user;

  Admin({
    required this.id,
    required this.userId,
    required this.establishmentId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.establishment,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      userId: json['user_id'],
      establishmentId: json['establishment_id'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      establishment: json['establishment'] != null
          ? Establishment.fromJson(json['establishment'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'establishment_id': establishmentId,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'establishment': establishment?.toJson(),
      'user': user?.toJson(),
    };
  }
}