class LateFeeRule {
  final int id;
  final int? establishmentId;
  final String name;
  final int daysOverdueMin;
  final int daysOverdueMax;
  final String feeType;
  final double feeValue;

  LateFeeRule({
    required this.id,
    this.establishmentId,
    required this.name,
    required this.daysOverdueMin,
    required this.daysOverdueMax,
    required this.feeType,
    required this.feeValue,
  });

  factory LateFeeRule.fromJson(Map<String, dynamic> json) {
    return LateFeeRule(
      id: json['id'],
      establishmentId: json['establishment_id'],
      name: json['name'],
      daysOverdueMin: json['days_overdue_min'],
      daysOverdueMax: json['days_overdue_max'],
      feeType: json['fee_type'],
      feeValue: json['fee_value'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'establishment_id': establishmentId,
      'name': name,
      'days_overdue_min': daysOverdueMin,
      'days_overdue_max': daysOverdueMax,
      'fee_type': feeType,
      'fee_value': feeValue,
    };
  }
}