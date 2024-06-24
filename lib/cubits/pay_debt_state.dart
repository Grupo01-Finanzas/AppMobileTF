// pay_debt_state.dart
part of 'pay_debt_cubit.dart';

abstract class PayDebtState extends Equatable {
  const PayDebtState();

  @override
  List<Object> get props => [];
}

class PayDebtInitial extends PayDebtState {}

class PayDebtLoading extends PayDebtState {}

class PayDebtSuccess extends PayDebtState {}

class PayDebtFailure extends PayDebtState {
  final String message;

  const PayDebtFailure({required this.message});

  @override
  List<Object> get props => [message];
}