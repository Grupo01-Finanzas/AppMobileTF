class ClientBalanceResponse {
  final int clientId;
  final double currentBalance;

  ClientBalanceResponse({
    required this.clientId,
    required this.currentBalance,
  });

  factory ClientBalanceResponse.fromJson(Map<String, dynamic> json) {
    return ClientBalanceResponse(
      clientId: json['client_id'],
      currentBalance: json['current_balance'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'current_balance': currentBalance,
    };
  }
}