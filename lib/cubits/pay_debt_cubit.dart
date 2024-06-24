// pay_debt_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tf/enum/payment_method.dart';
import 'package:tf/enum/transaction_type.dart';
import 'package:tf/repository/transaction_repository.dart';


part 'pay_debt_state.dart';

class PayDebtCubit extends Cubit<PayDebtState> {
  final TransactionRepository _transactionRepository;

  PayDebtCubit({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository,
        super(PayDebtInitial());

  Future<void> payDebt({
    required int creditAccountId,
    required TransactionType transactionType,
    required double amount,
    required PaymentMethod paymentMethod,
    required String confirmationCode,
    required String accessToken,
  }) async {
    emit(PayDebtLoading());
    try {
      await _transactionRepository.createTransaction(
        creditAccountId: creditAccountId,
        transactionType: transactionType.name, // Convert enum to string
        amount: amount,
        description: 'Payment', // You might want to customize this
        paymentMethod: paymentMethod.name, // Convert enum to string
        confirmationCode: confirmationCode,
        accessToken: accessToken,
      );
      emit(PayDebtSuccess());
    } catch (e) {
      emit(PayDebtFailure(message: e.toString()));
    }
  }
}