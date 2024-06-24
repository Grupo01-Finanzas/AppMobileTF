class AdminDebtSummary {
  final int clientId;
  final String clientName;
  final String creditType;
  final double interestRate;
  final int? numberOfDues; // Optional, for long-term credit
  final double currentBalance;
  final DateTime dueDate; // For short-term or next installment
  final int? daysOverdue; // Optional, for short-term credit
  final double? amountToPay; // Optional, for short-term credit
  final DateTime? nextDueDate; // Optional, for long-term credit

  AdminDebtSummary({
    required this.clientId,
    required this.clientName,
    required this.creditType,
    required this.interestRate,
    this.numberOfDues,
    required this.currentBalance,
    required this.dueDate,
    this.daysOverdue,
    this.amountToPay,
    this.nextDueDate,
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
      daysOverdue: json['days_overdue'],
      amountToPay: json['amount_to_pay']?.toDouble(),
      nextDueDate: json['next_due_date'] != null
          ? DateTime.parse(json['next_due_date'])
          : null,
    );
  }
}