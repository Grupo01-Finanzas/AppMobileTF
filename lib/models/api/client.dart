

import 'package:tf/models/api/credit_account.dart';
import 'package:tf/models/api/user.dart';

class Client {
  int id;
  User user;
  bool isActive;
  CreditAccount? creditAccount;

  Client({
    required this.id,
    required this.user,
    required this.isActive,
    this.creditAccount,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      user: User.fromJson(json['user']),
      isActive: json['is_active'],
      creditAccount: json['credit_account'] != null
          ? CreditAccount.fromJson(json['credit_account'])
          : null,
    );
  }
}