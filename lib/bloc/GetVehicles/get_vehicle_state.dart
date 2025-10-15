import 'package:apni_ride_user/model/get_vehicle_types.dart';

abstract class GetVehicleState {}

class GetVehicleInitial extends GetVehicleState {}

class GetVehicleLoading extends GetVehicleState {}

class GetVehicleSuccess extends GetVehicleState {
  final GetVehicleTypes getVehicles;

  GetVehicleSuccess(this.getVehicles);

  @override
  List<Object?> get props => [getVehicles];
}

class GetVehicleError extends GetVehicleState {
  final String message;

  GetVehicleError(this.message);
}
