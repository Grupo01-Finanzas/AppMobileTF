import 'package:tf/models/account_statement_response.dart';
import 'package:tf/models/admin_debt_summary.dart';

import 'api_service.dart';
import '../models/credit_account.dart';

class CreditAccountService {
  final ApiService _apiService;

  CreditAccountService(this._apiService);

  Future<void> createCreditAccount({
    required int establishmentId,
    required int clientId,
    required double creditLimit,
    required int monthlyDueDate,
    required double interestRate,
    required String interestType,
    required String creditType,
    int gracePeriod = 0,
    int? lateFeeRuleId,
  }) async {
    await _apiService.createCreditAccount(
      establishmentId: establishmentId,
      clientId: clientId,
      creditLimit: creditLimit,
      monthlyDueDate: monthlyDueDate,
      interestRate: interestRate,
      interestType: interestType,
      creditType: creditType,
      gracePeriod: gracePeriod,
      lateFeeRuleId: lateFeeRuleId,
    );
  }

  Future<CreditAccount> getCreditAccountById(int id) async {
    return await _apiService.getCreditAccountById(id);
  }

  Future<void> updateCreditAccount(
      int id, {
        double? creditLimit,
        int? monthlyDueDate,
        double? interestRate,
        String? interestType,
        String? creditType,
        int? gracePeriod,
        bool? isBlocked,
        int? lateFeeRuleId,
        double? currentBalance,
      }) async {
    await _apiService.updateCreditAccount(
      id,
      creditLimit: creditLimit,
      monthlyDueDate: monthlyDueDate,
      interestRate: interestRate,
      interestType: interestType,
      creditType: creditType,
      gracePeriod: gracePeriod,
      isBlocked: isBlocked,
      lateFeeRuleId: lateFeeRuleId,
      currentBalance: currentBalance,
    );
  }

  Future<void> deleteCreditAccount(int id) async {
    await _apiService.deleteCreditAccount(id);
  }

  Future<List<CreditAccount>> getCreditAccountsByEstablishmentId(
      int establishmentId) async {
    return await _apiService.getCreditAccountsByEstablishmentId(establishmentId);
  }

  Future<List<CreditAccount>> getCreditAccountsByClientId(int clientId) async {
    return await _apiService.getCreditAccountsByClientId(clientId);
  }

  Future<void> applyInterestToAllAccounts(int establishmentId) async {
    await _apiService.applyInterestToAllAccounts(establishmentId);
  }

  Future<void> applyLateFeesToAllAccounts(int establishmentId) async {
    await _apiService.applyLateFeesToAllAccounts(establishmentId);
  }

  Future<List<AdminDebtSummary>> getAdminDebtSummary(
      int establishmentId) async {
    return await _apiService.getAdminDebtSummary(establishmentId);
  }

  Future<void> processPurchase(
      int creditAccountId, double amount, String description) async {
    await _apiService.processPurchase(creditAccountId, amount, description);
  }

  Future<void> processPayment(
      int creditAccountId, double amount, String description) async {
    await _apiService.processPayment(creditAccountId, amount, description);
  }

  Future<void> assignCreditAccountToClient(
      int creditAccountId, int clientId) async {
    await _apiService.assignCreditAccountToClient(creditAccountId, clientId);
  }

  Future<AccountStatementResponse> getClientAccountHistory(int clientId) async {
    return await _apiService.getClientAccountHistory(clientId);
  }
}