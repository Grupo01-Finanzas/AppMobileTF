class LateFee {
  final int id;
  final int creditAccountId;
  final double amount;
  final DateTime appliedDate;

  LateFee({
    required this.id,
    required this.creditAccountId,
    required this.amount,
    required this.appliedDate,
  });

  factory LateFee.fromJson(Map<String, dynamic> json) {
    return LateFee(
      id: json['id'],
      creditAccountId: json['credit_account_id'],
      amount: json['amount'].toDouble(),
      appliedDate: DateTime.parse(json['applied_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'credit_account_id': creditAccountId,
      'amount': amount,
      'applied_date': appliedDate.toIso8601String(),
    };
  }
}