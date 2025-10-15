import 'package:apni_ride_user/model/driver_incentives.dart';
import 'package:apni_ride_user/model/get_vehicle_types.dart';

abstract class IncentivesState {}

class IncentivesInitial extends IncentivesState {}

class IncentivesLoading extends IncentivesState {}

class IncentivesSuccess extends IncentivesState {
  final DriverIncentives driverIncentives;

  IncentivesSuccess(this.driverIncentives);

  @override
  List<Object?> get props => [driverIncentives];
}

class IncentivesError extends IncentivesState {
  final String message;

  IncentivesError(this.message);
}
