import 'package:apni_ride_user/model/register_model.dart';

import '../../model/login_model.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterData registerData;

  RegisterSuccess(this.registerData);

  @override
  List<Object?> get props => [registerData];
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}
