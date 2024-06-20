import 'api_service.dart';
import '../models/late_fee.dart';

class LateFeeService {
  final ApiService _apiService;

  LateFeeService(this._apiService);

  Future<void> createLateFee(int creditAccountId, double amount) async {
    await _apiService.createLateFee(creditAccountId, amount);
  }

  Future<LateFee> getLateFeeById(int id) async {
    return await _apiService.getLateFeeById(id);
  }

  Future<void> updateLateFee(int id, double amount) async {
    await _apiService.updateLateFee(id, amount);
  }

  Future<void> deleteLateFee(int id) async {
    await _apiService.deleteLateFee(id);
  }

  Future<List<LateFee>> getLateFeesByCreditAccountId(int creditAccountId) async {
    return await _apiService.getLateFeesByCreditAccountId(creditAccountId);
  }
}