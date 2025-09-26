import 'package:equatable/equatable.dart';
import 'package:apni_ride_user/model/reached_location_data.dart';

abstract class ReachedLocationState extends Equatable {
  const ReachedLocationState();

  @override
  List<Object?> get props => [];
}

class ReachedLocationInitial extends ReachedLocationState {}

class ReachedLocationLoading extends ReachedLocationState {}

class ReachedLocationSuccess extends ReachedLocationState {
  final ReachedLocation reachedLocation;

  const ReachedLocationSuccess({required this.reachedLocation});

  @override
  List<Object?> get props => [reachedLocation];
}

class ReachedLocationError extends ReachedLocationState {
  final String error;

  const ReachedLocationError({required this.error});

  @override
  List<Object?> get props => [error];
}
