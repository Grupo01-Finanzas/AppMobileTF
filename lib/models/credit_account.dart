import 'package:tf/models/client.dart';
import 'package:tf/models/credit_request.dart';
import 'package:tf/models/late_fee_rule.dart';

class CreditAccount {
  final int id;
  final int establishmentId;
  final int clientId;
  final double creditLimit;
  final double currentBalance;
  final int monthlyDueDate;
  final double interestRate;
  final String interestType;
  final String creditType;
  final int gracePeriod;
  final bool isBlocked;
  final DateTime lastInterestAccrualDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? lateFeeRuleId;
  final Client? client;
  final LateFeeRule? lateFeeRule;
  List<CreditRequest> creditRequests;

  CreditAccount({
    required this.id,
    required this.establishmentId,
    required this.clientId,
    required this.creditLimit,
    required this.currentBalance,
    required this.monthlyDueDate,
    required this.interestRate,
    required this.interestType,
    required this.creditType,
    required this.gracePeriod,
    required this.isBlocked,
    required this.lastInterestAccrualDate,
    required this.createdAt,
    required this.updatedAt,
    this.lateFeeRuleId,
    this.client,
    this.lateFeeRule,
    required this.creditRequests,
  });

  factory CreditAccount.fromJson(Map<String, dynamic> json) {
    return CreditAccount(
      id: json['id'],
      establishmentId: json['establishment_id'],
      clientId: json['client_id'],
      creditLimit: json['credit_limit'].toDouble(),
      currentBalance: json['current_balance'].toDouble(),
      monthlyDueDate: json['monthly_due_date'],
      interestRate: json['interest_rate'].toDouble(),
      interestType: json['interest_type'],
      creditType: json['credit_type'],
      gracePeriod: json['grace_period'],
      isBlocked: json['is_blocked'],
      lastInterestAccrualDate:
          DateTime.parse(json['last_interest_accrual_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lateFeeRuleId: json['late_fee_rule_id'],
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
      lateFeeRule: json['late_fee_rule'] != null
          ? LateFeeRule.fromJson(json['late_fee_rule'])
          : null,
      creditRequests: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'establishment_id': establishmentId,
      'client_id': clientId,
      'credit_limit': creditLimit,
      'current_balance': currentBalance,
      'monthly_due_date': monthlyDueDate,
      'interest_rate': interestRate,
      'interest_type': interestType,
      'credit_type': creditType,
      'grace_period': gracePeriod,
      'is_blocked': isBlocked,
      'last_interest_accrual_date': lastInterestAccrualDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'late_fee_rule_id': lateFeeRuleId,
      'client': client?.toJson(),
      'late_fee_rule': lateFeeRule?.toJson(),
      'credit_requests': creditRequests.map((request) => request.toJson()).toList(),
    };
  }
}
