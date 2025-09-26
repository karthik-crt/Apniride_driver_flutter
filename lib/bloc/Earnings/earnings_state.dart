import 'package:apni_ride_user/model/earnings_data.dart';
import 'package:apni_ride_user/model/update_status.dart';

import '../../model/login_model.dart';

abstract class EarningsState {}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class EarningsSuccess extends EarningsState {
  final Earnings status;

  EarningsSuccess(this.status);

  @override
  List<Object?> get props => [status];
}

class EarningsError extends EarningsState {
  final String message;

  EarningsError(this.message);
}
