import 'package:tf/models/api/transaction_response.dart';
import 'package:tf/services/api/purchase_service.dart';
import 'package:tf/services/api/transaction_service.dart'; 

class TransactionRepository {
  final PurchaseService _purchaseService;
  final TransactionService _transactionService; 

  TransactionRepository({PurchaseService? purchaseService, TransactionService? transactionService}) 
    : _purchaseService = purchaseService ?? PurchaseService(), 
      _transactionService = transactionService ?? TransactionService();

  Future<List<TransactionResponse>> getTransactions(
      int userId, String accessToken) async {
    try {
      return await _purchaseService.getClientTransactionsU(userId, accessToken);
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow;
    }
  }

  Future<TransactionResponse> createTransaction({
    required int creditAccountId,
    required String transactionType,
    required double amount,
    required String description,
    required String paymentMethod, 
    required String confirmationCode, 
    required String accessToken,
  }) async {
    try {
      final response = await _transactionService.createTransaction(
        creditAccountId: creditAccountId,
        transactionType: transactionType,
        amount: amount,
        description: description,
        paymentMethod: paymentMethod,
        confirmationCode: confirmationCode, 
        accessToken: accessToken,
      );
      return TransactionResponse.fromJson(response);
    } catch (e) {
      print('Error creating transaction: $e');
      rethrow;
    }
  }


}