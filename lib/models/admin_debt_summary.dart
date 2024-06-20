class AdminDebtSummary {
  final int clientId;
  final String clientName;
  final String creditType;
  final double interestRate;
  final int numberOfDues;
  final double currentBalance;
  final DateTime dueDate;

  AdminDebtSummary({
    required this.clientId,
    required this.clientName,
    required this.creditType,
    required this.interestRate,
    required this.numberOfDues,
    required this.currentBalance,
    required this.dueDate,
  });

  factory AdminDebtSummary.fromJson(Map<String, dynamic> json) {
    return AdminDebtSummary(
      clientId: json['client_id'],
      clientName: json['client_name'],
      creditType: json['credit_type'],
      interestRate: json['interest_rate'].toDouble(),
      numberOfDues: json['number_of_installments'],
      currentBalance: json['current_balance'].toDouble(),
      dueDate: DateTime.parse(json['due_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'client_name': clientName,
      'credit_type': creditType,
      'interest_rate': interestRate,
      'number_of_installments': numberOfDues,
      'current_balance': currentBalance,
      'due_date': dueDate.toIso8601String(),
    };
  }
}
