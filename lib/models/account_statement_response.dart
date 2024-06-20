import 'package:tf/models/transaction.dart';

class AccountStatementResponse {
  final int clientId;
  final DateTime? startDate;
  final DateTime? endDate;
  final double startingBalance;
  final List<Transaction> transactions;

  AccountStatementResponse({
    required this.clientId,
    this.startDate,
    this.endDate,
    required this.startingBalance,
    required this.transactions,
  });

  factory AccountStatementResponse.fromJson(Map<String, dynamic> json) {
    return AccountStatementResponse(
      clientId: json['client_id'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      startingBalance: json['starting_balance'].toDouble(),
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'starting_balance': startingBalance,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }
}