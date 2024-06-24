import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/models/api/transaction_response.dart';
import 'package:tf/repository/transaction_repository.dart'; 

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository transactionRepository; 

  TransactionCubit({required this.transactionRepository}) : super(TransactionInitial());

  Future<void> fetchTransactions() async {
    emit(TransactionLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final userId = prefs.getInt('userId'); 

      if (accessToken != null && userId != null) {
        final transactions = await transactionRepository.getTransactions(userId, accessToken);
        emit(TransactionLoaded(transactions: transactions));
      } else {
        emit(const TransactionError(message: 'Access token or user ID not found')); 
      }

    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

   Future<void> fetchTransactionsId(int userId) async { // Now accepts userId
    emit(TransactionLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken != null) {
        final transactions =
            await transactionRepository.getTransactions(userId, accessToken);
        emit(TransactionLoaded(transactions: transactions));
      } else {
        emit(const TransactionError(message: 'Access token not found'));
      }
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }
}