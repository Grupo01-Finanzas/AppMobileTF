import 'api_service.dart';
import '../models/installment.dart';

class InstallmentService {
  final ApiService _apiService;

  InstallmentService(this._apiService);

  Future<void> createInstallment(
      int creditAccountId, DateTime dueDate, double amount, String status) async {
    await _apiService.createInstallment(
        creditAccountId, dueDate, amount, status);
  }

  Future<Installment> getInstallmentById(int id) async {
    return await _apiService.getInstallmentById(id);
  }

  Future<void> updateInstallment(
      int id, {
        DateTime? dueDate,
        double? amount,
        String? status,
      }) async {
    await _apiService.updateInstallment(
      id,
      dueDate: dueDate,
      amount: amount,
      status: status,
    );
  }

  Future<void> deleteInstallment(int id) async {
    await _apiService.deleteInstallment(id);
  }

  Future<List<Installment>> getInstallmentsByCreditAccountId(
      int creditAccountId) async {
    return await _apiService.getInstallmentsByCreditAccountId(creditAccountId);
  }

  Future<List<Installment>> getOverdueInstallmentsByCreditAccountId(
      int creditAccountId) async {
    return await _apiService.getOverdueInstallmentsByCreditAccountId(
        creditAccountId);
  }
}