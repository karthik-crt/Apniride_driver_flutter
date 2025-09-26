import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apni_ride_user/model/start_trip.dart';
import '../../utills/api_service.dart';
import 'start_trip_state.dart';

class StartTripCubit extends Cubit<StartTripState> {
  final ApiService apiService;

  StartTripCubit(this.apiService) : super(StartTripInitial());

  Future<void> startTrip(String rideId, String otp) async {
    try {
      emit(StartTripLoading());
      final data = {"otp": otp};
      final response = await apiService.startTrip(rideId, data);
      if (response.StatusCode != 1) {
        emit(StartTripError(error: response.message.toString()));
      } else {
        emit(StartTripSuccess(startTrip: response));
      }
    } catch (e) {
      emit(StartTripError(error: e.toString()));
    }
  }
}
