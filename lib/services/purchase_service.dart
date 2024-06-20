import 'api_service.dart';
import '../models/client_balance_response.dart';
import '../models/installment.dart';
import '../models/transaction.dart';
import '../models/credit_account.dart';

class PurchaseService {
  final ApiService _apiService;

  PurchaseService(this._apiService);

  Future<void> createPurchase(
    int establishmentId,
    List<int> productIds,
    String creditType,
    double amount,
  ) async {
    await _apiService.createPurchase(
        establishmentId, productIds, creditType, amount);
  }

  Future<ClientBalanceResponse> getClientBalance(int clientId) async {
    return await _apiService.getClientBalance(clientId);
  }

  Future<List<Transaction>> getClientTransactions(int clientId) async {
    return await _apiService.getClientTransactions(clientId);
  }

  Future<double> getClientOverdueBalance(int clientId) async {
    return await _apiService.getClientOverdueBalance(clientId);
  }

  Future<List<Installment>> getClientInstallments(int clientId) async {
    return await _apiService.getClientInstallments(clientId);
  }

  Future<CreditAccount> getClientCreditAccount(int clientId) async {
    return await _apiService.getClientCreditAccount(clientId);
  }
}