import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';
import 'cancel_trip_state.dart';

class CancelTripCubit extends Cubit<CancelTripState> {
  final ApiService apiService;

  CancelTripCubit(this.apiService) : super(CancelTripInitial());

  Future<void> CancelRide(String rideId, String status) async {
    try {
      emit(CancelTripLoading());
      print("rideId ${rideId}");
      final response = await apiService.cancelTrip(rideId);
      if (response.statusCode != "1") {
        emit(CancelTripError(error: response.statusMessage.toString()));
      } else {
        emit(CancelTripSuccess(cancelTrip: response));
      }
    } catch (e) {
      emit(CancelTripError(error: e.toString()));
    }
  }
}
