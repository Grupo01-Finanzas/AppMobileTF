import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/services/api/user_service.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final UserService userService;

  ChangePasswordCubit({required this.userService}) : super(ChangePasswordInitial());

  Future<void> updatePassword({required String newPassword}) async {
    emit(ChangePasswordLoading());
    try {
      // Get the user ID from SharedPreferences or wherever you store it
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) {
        throw Exception('User ID not found in shared preferences.');
      }

      // Get the access token from SharedPreferences
      final accessToken = prefs.getString('accessToken');
      if (accessToken == null) {
        throw Exception('Access token not found in shared preferences.');
      }

      // Call the UserService to update the password
      await userService.updatePassword(
        userId: userId,
        newPassword: newPassword,
        accessToken: accessToken,
      );
      emit(ChangePasswordSuccess());
    } catch (error) {
      emit(ChangePasswordFailure(error: error.toString()));
    }
  }
}