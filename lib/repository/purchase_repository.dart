// purchase_repository.dart

import 'package:tf/services/api/purchase_service.dart';

class PurchaseRepository {
  final PurchaseService _purchaseService;

  PurchaseRepository({PurchaseService? purchaseService})
      : _purchaseService = purchaseService ?? PurchaseService();

  Future<void> createPurchase({
    required String accessToken,
    required int establishmentID,
    required List<int> productIds,
    required String creditType,
    required double amount,
  }) async {
    try {
      await _purchaseService.createPurchase(
        accessToken: accessToken,
        establishmentID: establishmentID,
        productIds: productIds,
        creditType: creditType, // Pass the credit type string
        amount: amount,
      );
    } catch (e) {
      print('Error creating purchase: $e');
      rethrow;
    }
  }
}