part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthRegisterLoading extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterFailure extends AuthState {
  final String error;

  const AuthRegisterFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class AuthLoginLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final Map<String, dynamic> token;

  const AuthLoginSuccess({required this.token});

  @override
  List<Object?> get props => [token];
}

class AuthLoginFailure extends AuthState {
  final String error;

  const AuthLoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class AuthRefreshTokenLoading extends AuthState {}

class AuthRefreshTokenSuccess extends AuthState {
  final Map<String, dynamic> token;

  const AuthRefreshTokenSuccess({required this.token});

  @override
  List<Object?> get props => [token];
}

class AuthRefreshTokenFailure extends AuthState {
  final String error;

  const AuthRefreshTokenFailure({required this.error});

  @override
  List<Object?> get props => [error];
}