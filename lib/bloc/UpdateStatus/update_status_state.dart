import 'package:apni_ride_user/model/update_status.dart';

import '../../model/login_model.dart';

abstract class UpdateStatusState {}

class UpdateStatusInitial extends UpdateStatusState {}

class UpdateStatusLoading extends UpdateStatusState {}

class UpdateStatusSuccess extends UpdateStatusState {
  final UpdateStatus status;

  UpdateStatusSuccess(this.status);

  @override
  List<Object?> get props => [status];
}

class UpdateStatusError extends UpdateStatusState {
  final String message;

  UpdateStatusError(this.message);
}
