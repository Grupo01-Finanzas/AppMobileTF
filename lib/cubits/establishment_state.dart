part of 'establishment_cubit.dart';

abstract class EstablishmentState extends Equatable {
  const EstablishmentState();

  @override
  List<Object> get props => [];
}

class EstablishmentInitial extends EstablishmentState {}

class EstablishmentLoading extends EstablishmentState {}

class EstablishmentLoaded extends EstablishmentState {
  final Establishment establishment;

  const EstablishmentLoaded({required this.establishment});

  @override
  List<Object> get props => [establishment];
}

class EstablishmentError extends EstablishmentState {
  final String message;

  const EstablishmentError({required this.message});

  @override
  List<Object> get props => [message];
}