// account_summary_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tf/models/api/account_summary.dart';
import 'package:tf/repository/account_summary_repository.dart';


part 'account_summary_state.dart';

class AccountSummaryCubit extends Cubit<AccountSummaryState> {
  final AccountSummaryRepository _accountSummaryRepository;

  AccountSummaryCubit({required AccountSummaryRepository accountSummaryRepository})
      : _accountSummaryRepository = accountSummaryRepository,
        super(AccountSummaryInitial());

  Future<void> fetchAccountSummary(String accessToken) async {
    emit(AccountSummaryLoading());
    try {
      final accountSummary = await _accountSummaryRepository.getAccountSummary(accessToken);
      emit(AccountSummaryLoaded(accountSummary: accountSummary));
    } catch (e) {
      emit(AccountSummaryError(message: e.toString()));
    }
  }
}