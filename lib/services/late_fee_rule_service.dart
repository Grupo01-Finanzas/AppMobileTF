import 'api_service.dart';
import '../models/late_fee_rule.dart';

class LateFeeRuleService {
  final ApiService _apiService;

  LateFeeRuleService(this._apiService);

  Future<void> createLateFeeRule({
    int? establishmentId,
    required String name,
    required int daysOverdueMin,
    required int daysOverdueMax,
    required String feeType,
    required double feeValue,
  }) async {
    await _apiService.createLateFeeRule(
      establishmentId: establishmentId,
      name: name,
      daysOverdueMin: daysOverdueMin,
      daysOverdueMax: daysOverdueMax,
      feeType: feeType,
      feeValue: feeValue,
    );
  }

  Future<LateFeeRule> getLateFeeRuleById(int id) async {
    return await _apiService.getLateFeeRuleById(id);
  }

  Future<void> updateLateFeeRule(
      int id, {
        String? name,
        int? daysOverdueMin,
        int? daysOverdueMax,
        String? feeType,
        double? feeValue,
      }) async {
    await _apiService.updateLateFeeRule(
      id,
      name: name,
      daysOverdueMin: daysOverdueMin,
      daysOverdueMax: daysOverdueMax,
      feeType: feeType,
      feeValue: feeValue,
    );
  }

  Future<void> deleteLateFeeRule(int id) async {
    await _apiService.deleteLateFeeRule(id);
  }

  Future<List<LateFeeRule>> getAllLateFeeRules() async {
    return await _apiService.getAllLateFeeRules();
  }

  Future<List<LateFeeRule>> getLateFeeRulesByEstablishmentId(
      int establishmentId) async {
    return await _apiService.getLateFeeRulesByEstablishmentId(establishmentId);
  }
}