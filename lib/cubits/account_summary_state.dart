// account_summary_state.dart
part of 'account_summary_cubit.dart';

abstract class AccountSummaryState extends Equatable {
  const AccountSummaryState();

  @override
  List<Object> get props => [];
}

class AccountSummaryInitial extends AccountSummaryState {}

class AccountSummaryLoading extends AccountSummaryState {}

class AccountSummaryLoaded extends AccountSummaryState {
  final AccountSummary accountSummary; 

  const AccountSummaryLoaded({required this.accountSummary});

  @override
  List<Object> get props => [accountSummary];
}

class AccountSummaryError extends AccountSummaryState {
  final String message;

  const AccountSummaryError({required this.message});

  @override
  List<Object> get props => [message];
}