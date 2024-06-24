// purchase_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tf/repository/purchase_repository.dart';


part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PurchaseRepository _purchaseRepository;

  PurchaseCubit({required PurchaseRepository purchaseRepository})
      : _purchaseRepository = purchaseRepository,
        super(PurchaseInitial());

  Future<void> createPurchase({
    required String accessToken,
    required int establishmentID,
    required List<int> productIds,
    required String creditType,
    required double amount,
  }) async {
    emit(PurchaseLoading());
    try {
      await _purchaseRepository.createPurchase(
        accessToken: accessToken,
        establishmentID: establishmentID,
        productIds: productIds,
        creditType: creditType,
        amount: amount,
      );
      emit(PurchaseSuccess());
    } catch (e) {
      emit(PurchaseFailure(message: e.toString()));
    }
  }
}