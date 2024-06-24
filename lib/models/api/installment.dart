

import 'package:tf/models/api/credit_account.dart';

class Installment {
  int id;
  int creditAccountID;
  CreditAccount creditAccount;
  DateTime dueDate; // Use DateTime instead of string
  double amount;
  String status; // Consider using an enum

  Installment({
    required this.id,
    required this.creditAccountID,
    required this.creditAccount,
    required this.dueDate,
    required this.amount,
    required this.status,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      id: json['id'],
      creditAccountID: json['credit_account_id'],
      creditAccount: CreditAccount.fromJson(json['credit_account']),
      dueDate: DateTime.parse(json['due_date']),
      amount: json['amount'],
      status: json['status'],
    );
  }
}
