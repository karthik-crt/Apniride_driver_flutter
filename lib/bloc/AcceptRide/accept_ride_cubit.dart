import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';
import 'accept_ride_state.dart';

class AcceptRideCubit extends Cubit<AcceptRideState> {
  final ApiService apiService;

  AcceptRideCubit(this.apiService) : super(AcceptRideInitial());

  Future<void> acceptRide(
    String rideId,
    Map<String, dynamic> data,
    BuildContext context,
  ) async {
    emit(AcceptRideLoading());
    print("Submitting login data...");
    print("Data ${data}");
    try {
      final rideData = await apiService.acceptRide(rideId, data);
      print("register");
      print(rideData.statusCode);
      if (rideData.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(rideData.statusMessage ?? "")));
        emit(AcceptRideError(rideData.statusMessage ?? ""));
      } else {
        emit(AcceptRideSuccess(rideData));
      }
    } catch (e) {
      print("Ride error: $e");
      emit(AcceptRideError(e.toString()));
    }
  }
}
