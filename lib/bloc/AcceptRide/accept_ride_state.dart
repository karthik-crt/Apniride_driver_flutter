import 'package:apni_ride_user/model/ride_accept.dart';
import 'package:apni_ride_user/model/update_status.dart';

import '../../model/login_model.dart';

abstract class AcceptRideState {}

class AcceptRideInitial extends AcceptRideState {}

class AcceptRideLoading extends AcceptRideState {}

class AcceptRideSuccess extends AcceptRideState {
  final AcceptRide acceptRide;

  AcceptRideSuccess(this.acceptRide);

  @override
  List<Object?> get props => [acceptRide];
}

class AcceptRideError extends AcceptRideState {
  final String message;

  AcceptRideError(this.message);
}
