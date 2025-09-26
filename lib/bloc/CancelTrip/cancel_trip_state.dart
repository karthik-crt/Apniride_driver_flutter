import 'package:apni_ride_user/model/cancel_trip.dart';
import 'package:apni_ride_user/model/trip_complete.dart';
import 'package:equatable/equatable.dart';
import 'package:apni_ride_user/model/start_trip.dart';

abstract class CancelTripState extends Equatable {
  const CancelTripState();

  @override
  List<Object?> get props => [];
}

class CancelTripInitial extends CancelTripState {}

class CancelTripLoading extends CancelTripState {}

class CancelTripSuccess extends CancelTripState {
  final CancelTrip cancelTrip;

  const CancelTripSuccess({required this.cancelTrip});

  @override
  List<Object?> get props => [cancelTrip];
}

class CancelTripError extends CancelTripState {
  final String error;

  const CancelTripError({required this.error});

  @override
  List<Object?> get props => [error];
}
