import 'package:equatable/equatable.dart';
import 'package:apni_ride_user/model/start_trip.dart';

abstract class StartTripState extends Equatable {
  const StartTripState();

  @override
  List<Object?> get props => [];
}

class StartTripInitial extends StartTripState {}

class StartTripLoading extends StartTripState {}

class StartTripSuccess extends StartTripState {
  final StartTrip startTrip;

  const StartTripSuccess({required this.startTrip});

  @override
  List<Object?> get props => [startTrip];
}

class StartTripError extends StartTripState {
  final String error;

  const StartTripError({required this.error});

  @override
  List<Object?> get props => [error];
}
