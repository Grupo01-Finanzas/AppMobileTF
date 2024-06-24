// installment_state.dart
part of 'installment_cubit.dart';



abstract class InstallmentState extends Equatable {
  const InstallmentState();

  @override
  List<Object> get props => [];
}

class InstallmentInitial extends InstallmentState {}

class InstallmentLoading extends InstallmentState {}

class InstallmentLoaded extends InstallmentState {
  final List<InstallmentResponse> installments;

  const InstallmentLoaded({required this.installments});

  @override
  List<Object> get props => [installments];
}

class InstallmentError extends InstallmentState {
  final String message;

  const InstallmentError({required this.message});

  @override
  List<Object> get props => [message];
}