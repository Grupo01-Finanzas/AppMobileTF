// account_summary_repository.dart
import 'package:tf/models/api/account_summary.dart'; 
import 'package:tf/services/api/purchase_service.dart'; 

class AccountSummaryRepository {
  final PurchaseService _purchaseService; 

  AccountSummaryRepository({PurchaseService? purchaseService})
    : _purchaseService = purchaseService ?? PurchaseService();

  Future<AccountSummary> getAccountSummary(String accessToken) async {
    try {
      final response = await _purchaseService.getClientAccountSummary(accessToken: accessToken);
      return AccountSummary.fromJson(response);
    } catch (e) {
      print('Error fetching account summary: $e'); 
      rethrow;
    }
  }
}