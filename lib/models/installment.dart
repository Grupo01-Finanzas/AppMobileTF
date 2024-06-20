class Installment {
  final int id;
  final int creditAccountId;
  final DateTime dueDate;
  final double amount;
  final String status;

  Installment({
    required this.id,
    required this.creditAccountId,
    required this.dueDate,
    required this.amount,
    required this.status,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      id: json['id'],
      creditAccountId: json['credit_account_id'],
      dueDate: DateTime.parse(json['due_date']),
      amount: json['amount'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'credit_account_id': creditAccountId,
      'due_date': dueDate.toIso8601String(),
      'amount': amount,
      'status': status,
    };
  }
}
