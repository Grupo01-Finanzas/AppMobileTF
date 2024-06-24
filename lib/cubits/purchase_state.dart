// purchase_state.dart
part of 'purchase_cubit.dart';

abstract class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object> get props => [];
}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseSuccess extends PurchaseState {}

class PurchaseFailure extends PurchaseState {
  final String message;

  const PurchaseFailure({required this.message});

  @override
  List<Object> get props => [message];
}