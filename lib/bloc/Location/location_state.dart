import 'package:apni_ride_user/model/location_update.dart';

import '../../model/login_model.dart';

abstract class LocationUpdateState {}

class LocationUpdateInitial extends LocationUpdateState {}

class LocationUpdateLoading extends LocationUpdateState {}

class LocationUpdateSuccess extends LocationUpdateState {
  final LocationUpdate locationData;

  LocationUpdateSuccess(this.locationData);

  @override
  List<Object?> get props => [locationData];
}

class LocationUpdateError extends LocationUpdateState {
  final String message;

  LocationUpdateError(this.message);
}
