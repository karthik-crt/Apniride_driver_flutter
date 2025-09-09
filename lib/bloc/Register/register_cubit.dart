import 'package:apni_ride_user/bloc/Register/register_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utills/api_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiService apiService;

  RegisterCubit(this.apiService) : super(RegisterInitial());

  Future<void> register(FormData data, context) async {
    emit(RegisterLoading());
    print("Submitting login data...");
    print("Data ${data.fields}");
    try {
      final RegisterData = await apiService.registerData(data);
      print("register");
      print(RegisterData.statusCode);
      if (RegisterData.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(RegisterData.statusMessage)));
        emit(RegisterError(RegisterData.statusMessage));
      } else {
        emit(RegisterSuccess(RegisterData));
      }
    } catch (e) {
      print("Login error: $e");
      emit(RegisterError(e.toString()));
    }
  }
}
