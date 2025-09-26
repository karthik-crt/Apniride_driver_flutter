import 'package:apni_ride_user/bloc/TripComplete/trip_complete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';

class CompleteTripCubit extends Cubit<CompleteTripState> {
  final ApiService apiService;

  CompleteTripCubit(this.apiService) : super(CompleteTripInitial());

  Future<void> completeTrip(String rideId, String status) async {
    try {
      emit(CompleteTripLoading());
      final data = {"status": status};
      print("data ${data}");
      print("rideId ${rideId}");
      final response = await apiService.completedTrip(rideId, data);
      if (response.statusCode != "1") {
        emit(CompleteTripError(error: response.statusMessage.toString()));
      } else {
        emit(CompleteTripSuccess(completeTrip: response));
      }
    } catch (e) {
      emit(CompleteTripError(error: e.toString()));
    }
  }
}
