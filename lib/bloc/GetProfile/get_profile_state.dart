import 'package:apni_ride_user/model/get_profile_model.dart';
import 'package:apni_ride_user/model/update_status.dart';

import '../../model/login_model.dart';

abstract class GetProfileState {}

class GetProfileInitial extends GetProfileState {}

class GetProfileLoading extends GetProfileState {}

class GetProfileSuccess extends GetProfileState {
  final GetProfile getProfile;

  GetProfileSuccess(this.getProfile);

  @override
  List<Object?> get props => [getProfile];
}

class GetProfileError extends GetProfileState {
  final String message;

  GetProfileError(this.message);
}
