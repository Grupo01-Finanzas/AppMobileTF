
import 'package:tf/models/api/establishment.dart';
import 'package:tf/models/api/user.dart';

class Admin {
  int id;
  User user;
  Establishment establishment;
  bool isActive;

  Admin({
    required this.id,
    required this.user,
    required this.establishment,
    required this.isActive,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      user: User.fromJson(json['user']),
      establishment: Establishment.fromJson(json['establishment']),
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'establishment': establishment
      };
  }
}
