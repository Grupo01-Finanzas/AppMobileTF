class Transaction {
  final int id;
  final int creditAccountId;
  final String transactionType;
  final double amount;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.creditAccountId,
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      creditAccountId: json['credit_account_id'],
      transactionType: json['transaction_type'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'credit_account_id': creditAccountId,
      'transaction_type': transactionType,
      'amount': amount,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
