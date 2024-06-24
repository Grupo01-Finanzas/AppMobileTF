import 'package:tf/models/api/transaction_response.dart';
import 'package:tf/services/api/purchase_service.dart'; 

class TransactionRepository {
  final PurchaseService _purchaseService; 

  TransactionRepository({PurchaseService? purchaseService}) 
    : _purchaseService = purchaseService ?? PurchaseService();

  Future<List<TransactionResponse>> getTransactions(
      int userId, String accessToken) async {
    try {
      return await _purchaseService.getClientTransactionsU(userId, accessToken);
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow;
    }
  }

}