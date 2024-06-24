

import 'package:tf/models/api/credit_account.dart';

class Transaction {
  int id;
  int creditAccountID;
  CreditAccount creditAccount;
  String transactionType; // Consider using an enum
  double amount;
  String description;
  DateTime transactionDate; // Use DateTime instead of string
  String paymentMethod; // Consider using an enum
  String paymentCode;
  String confirmationCode;
  String paymentStatus; // Consider using an enum

  Transaction({
    required this.id,
    required this.creditAccountID,
    required this.creditAccount,
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.transactionDate,
    required this.paymentMethod,
    required this.paymentCode,
    required this.confirmationCode,
    required this.paymentStatus,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      creditAccountID: json['credit_account_id'],
      creditAccount: CreditAccount.fromJson(json['credit_account']),
      transactionType: json['transaction_type'],
      amount: json['amount'],
      description: json['description'],
      transactionDate: DateTime.parse(json['transaction_date']),
      paymentMethod: json['payment_method'],
      paymentCode: json['payment_code'],
      confirmationCode: json['confirmation_code'],
      paymentStatus: json['payment_status'],
    );
  }
}