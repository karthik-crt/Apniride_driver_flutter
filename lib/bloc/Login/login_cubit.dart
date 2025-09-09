import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utills/api_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final ApiService apiService;

  LoginCubit(this.apiService) : super(LoginInitial());

  Future<void> login(Map<String, dynamic> data, context) async {
    emit(LoginLoading());
    print("Submitting login data...");
    try {
      print("loginData ${data}");
      final LoginData = await apiService.login(data);
      print("loginlogin");
      print(LoginData.statusCode);
      if (LoginData.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(LoginData.statusMessage)));
        emit(LoginError(LoginData.statusMessage));
      } else {
        emit(LoginSuccess(LoginData));
        if (LoginData.isOldUser) {
          print("yaa this is old user");
          SharedPreferenceHelper.setToken(LoginData.access);
          SharedPreferenceHelper.setId(LoginData.id);
          print(
            "SharedPreference ${SharedPreferenceHelper.getToken()}   ${SharedPreferenceHelper.getId()}",
          );
        }
      }
    } catch (e) {
      print("Login error: $e");
      emit(LoginError(e.toString()));
    }
  }
}
