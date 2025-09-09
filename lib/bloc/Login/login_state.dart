import '../../model/login_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginData login;
  LoginSuccess(this.login);
  @override
  List<Object?> get props => [login];
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
