class TransactionResponse {
  final int id;
  final int creditAccountId; 
  final String transactionType; 
  final double amount;
  final String? description;
  final DateTime transactionDate;
  final String paymentMethod; 
  final String? paymentCode; 
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionResponse({
    required this.id,
    required this.creditAccountId,
    required this.transactionType,
    required this.amount,
    this.description,
    required this.transactionDate,
    required this.paymentMethod,
    this.paymentCode,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      id: json['id'],
      creditAccountId: json['credit_account_id'],
      transactionType: json['transaction_type'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      transactionDate: DateTime.parse(json['transaction_date']),
      paymentMethod: json['payment_method'],
      paymentCode: json['payment_code'],
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}