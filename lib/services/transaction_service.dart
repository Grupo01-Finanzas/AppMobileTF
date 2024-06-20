import 'api_service.dart';
import '../models/transaction.dart';

class TransactionService {
  final ApiService _apiService;

  TransactionService(this._apiService);

  Future<void> createTransaction(
      int creditAccountId,
      String transactionType,
      double amount,
      String recipientType,
      int recipientId,
      {String? description}) async {
    await _apiService.createTransaction(creditAccountId, transactionType,
        amount, recipientType, recipientId,
        description: description);
  }

  Future<Transaction> getTransactionById(int id) async {
    return await _apiService.getTransactionById(id);
  }

  Future<void> updateTransaction(
      int id, {
        double? amount,
        String? description,
        String? transactionType,
      }) async {
    await _apiService.updateTransaction(
      id,
      amount: amount,
      description: description,
      transactionType: transactionType,
    );
  }

  Future<void> deleteTransaction(int id) async {
    await _apiService.deleteTransaction(id);
  }

  Future<List<Transaction>> getTransactionsByCreditAccountId(
      int creditAccountId) async {
    return await _apiService.getTransactionsByCreditAccountId(creditAccountId);
  }
}