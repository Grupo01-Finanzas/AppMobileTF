class InstallmentResponse {
  final int id;
  final int creditAccountId;
  final String dueDate; 
  final double amount;
  final String status; // Assuming status is a string (e.g., "PENDING", "PAID", etc.)
  final DateTime createdAt;
  final DateTime updatedAt;

  InstallmentResponse({
    required this.id,
    required this.creditAccountId,
    required this.dueDate,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstallmentResponse.fromJson(Map<String, dynamic> json) {
    return InstallmentResponse(
      id: json['id'] as int,
      creditAccountId: json['credit_account_id'] as int,
      dueDate: json['due_date'] as String, // Assuming dueDate is a string
      amount: json['amount'] as double,
      status: json['status'] as String, // Assuming status is a string
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}