import 'package:apni_ride_user/bloc/Register/register_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utills/api_service.dart';
import 'location_state.dart';

class LocationUpdateCubit extends Cubit<LocationUpdateState> {
  final ApiService apiService;

  LocationUpdateCubit(this.apiService) : super(LocationUpdateInitial());

  Future<void> updateLocation(Map<String, dynamic> data, context) async {
    emit(LocationUpdateLoading());
    print("Submitting login data...");
    print("Data ${data}");
    try {
      final locationData = await apiService.updateLocation(data);
      print("register");
      print(locationData.statusCode);
      if (locationData.statusCode != '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locationData.statusMessage ?? "")),
        );
        emit(LocationUpdateError(locationData.statusMessage ?? ""));
      } else {
        emit(LocationUpdateSuccess(locationData));
      }
    } catch (e) {
      print("Login error: $e");
      emit(LocationUpdateError(e.toString()));
    }
  }
}
