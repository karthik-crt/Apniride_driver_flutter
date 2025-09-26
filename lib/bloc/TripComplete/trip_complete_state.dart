import 'package:apni_ride_user/model/trip_complete.dart';
import 'package:equatable/equatable.dart';
import 'package:apni_ride_user/model/start_trip.dart';

abstract class CompleteTripState extends Equatable {
  const CompleteTripState();

  @override
  List<Object?> get props => [];
}

class CompleteTripInitial extends CompleteTripState {}

class CompleteTripLoading extends CompleteTripState {}

class CompleteTripSuccess extends CompleteTripState {
  final TripCompleted completeTrip;

  const CompleteTripSuccess({required this.completeTrip});

  @override
  List<Object?> get props => [completeTrip];
}

class CompleteTripError extends CompleteTripState {
  final String error;

  const CompleteTripError({required this.error});

  @override
  List<Object?> get props => [error];
}
