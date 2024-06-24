import 'package:tf/models/api/credit_account.dart';
import 'package:tf/models/api/installment_response.dart';

import 'package:tf/models/api/transaction_response.dart'; 

class AccountSummary {
  final CreditAccount creditAccount; 
  final double totalPurchases;
  final double totalPayments;
  final double totalInterest; 
  final int outstandingDues;
  final List<TransactionResponse> transactions; 
  final List<InstallmentResponse> outstandingInstallments; 

  AccountSummary({
    required this.creditAccount,
    required this.totalPurchases,
    required this.totalPayments,
    required this.totalInterest,
    required this.outstandingDues,
    required this.transactions,
    required this.outstandingInstallments,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) {
    // 1. Parse the CreditAccount
    final creditAccountJson = json['credit_account'];
    final creditAccount = CreditAccount.fromJson(creditAccountJson);

    // 2. Parse the Transactions
    final transactionsJson = json['transactions'] as List<dynamic>?; 
    final transactions = transactionsJson != null
        ? transactionsJson.map((transaction) => TransactionResponse.fromJson(transaction)).toList()
        : <TransactionResponse>[];

    // 3. Parse the Outstanding Installments
    final outstandingInstallmentsJson = json['outstanding_installments'] as List<dynamic>?;
    final outstandingInstallments = outstandingInstallmentsJson != null
        ? outstandingInstallmentsJson.map((installment) => InstallmentResponse.fromJson(installment)).toList()
        : <InstallmentResponse>[];

    return AccountSummary(
      creditAccount: creditAccount,
      totalPurchases: (json['total_purchases'] as num?)?.toDouble() ?? 0.0,
      totalPayments: (json['total_payments'] as num?)?.toDouble() ?? 0.0,
      totalInterest: (json['total_interest'] as num?)?.toDouble() ?? 0.0,
      outstandingDues: json['outstanding_dues'] as int? ?? 0,
      transactions: transactions,
      outstandingInstallments: outstandingInstallments,
    );
  }
}