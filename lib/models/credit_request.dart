class CreditRequest {
  final int id;
  final int clientId;
  final int establishmentId;
  final double requestedCreditLimit;
  final int monthlyDueDate;
  final String interestType;
  final String creditType;
  final int gracePeriod;
  final String status;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool read;

  CreditRequest({
    required this.id,
    required this.clientId,
    required this.establishmentId,
    required this.requestedCreditLimit,
    required this.monthlyDueDate,
    required this.interestType,
    required this.creditType,
    required this.gracePeriod,
    required this.status,
    this.approvedAt,
    this.rejectedAt,
    required this.createdAt,
    required this.updatedAt,
    this.read = false,
  });

  factory CreditRequest.fromJson(Map<String, dynamic> json) {
    return CreditRequest(
      id: json['id'],
      clientId: json['client_id'],
      establishmentId: json['establishment_id'],
      requestedCreditLimit: json['requested_credit_limit'].toDouble(),
      monthlyDueDate: json['monthly_due_date'],
      interestType: json['interest_type'],
      creditType: json['credit_type'],
      gracePeriod: json['grace_period'],
      status: json['status'],
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
      rejectedAt: json['rejected_at'] != null
          ? DateTime.parse(json['rejected_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      read: json['read'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'establishment_id': establishmentId,
      'requested_credit_limit': requestedCreditLimit,
      'monthly_due_date': monthlyDueDate,
      'interest_type': interestType,
      'credit_type': creditType,
      'grace_period': gracePeriod,
      'status': status,
      'approved_at': approvedAt?.toIso8601String(),
      'rejected_at': rejectedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'read': read,
    };
  }
}
