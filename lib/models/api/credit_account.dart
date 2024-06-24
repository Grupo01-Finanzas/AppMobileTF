

import 'package:tf/models/api/client.dart';
import 'package:tf/models/api/establishment.dart';

class CreditAccount {
  int id;
  int clientID;
  Client client;
  int establishmentID;
  Establishment establishment;
  double creditLimit;
  double currentBalance;
  int monthlyDueDate;
  double interestRate;
  String interestType; // Consider using an enum
  String creditType; // Consider using an enum
  int gracePeriod;
  bool isBlocked;
  DateTime lastInterestAccrualDate; // Use DateTime instead of string
  double lateFeePercentage;

  CreditAccount({
    required this.id,
    required this.clientID,
    required this.client,
    required this.establishmentID,
    required this.establishment,
    required this.creditLimit,
    required this.currentBalance,
    required this.monthlyDueDate,
    required this.interestRate,
    required this.interestType,
    required this.creditType,
    required this.gracePeriod,
    required this.isBlocked,
    required this.lastInterestAccrualDate,
    required this.lateFeePercentage,
  });

  factory CreditAccount.fromJson(Map<String, dynamic> json) {
    return CreditAccount(
      id: json['id'],
      clientID: json['client_id'],
      client: Client.fromJson(json['client']),
      establishmentID: json['establishment_id'],
      establishment: Establishment.fromJson(json['establishment']),
      creditLimit: json['credit_limit'],
      currentBalance: json['current_balance'],
      monthlyDueDate: json['monthly_due_date'],
      interestRate: json['interest_rate'],
      interestType: json['interest_type'],
      creditType: json['credit_type'],
      gracePeriod: json['grace_period'],
      isBlocked: json['is_blocked'],
      lastInterestAccrualDate: DateTime.parse(json['last_interest_accrual_date']),
      lateFeePercentage: json['late_fee_percentage'],
    );
  }
}