import 'package:apni_ride_user/model/reject_ride.dart';

abstract class RejectRideState {}

class RejectRideInitial extends RejectRideState {}

class RejectRideLoading extends RejectRideState {}

class RejectRideSuccess extends RejectRideState {
  final RejectRide reject;

  RejectRideSuccess(this.reject);

  @override
  List<Object?> get props => [reject];
}

class RejectRideError extends RejectRideState {
  final String message;

  RejectRideError(this.message);
}
