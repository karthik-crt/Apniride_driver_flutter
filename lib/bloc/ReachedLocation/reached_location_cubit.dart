import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apni_ride_user/model/reached_location_data.dart';

import '../../utills/api_service.dart';
import 'reached_location_state.dart';

class ReachedLocationCubit extends Cubit<ReachedLocationState> {
  final ApiService apiService;

  ReachedLocationCubit(this.apiService) : super(ReachedLocationInitial());

  Future<void> fetchReachedLocation(String rideId) async {
    try {
      emit(ReachedLocationLoading());
      final response = await apiService.reachedLocation(rideId);
      if (response.StatusCode != 1) {
        emit(ReachedLocationError(error: response.message.toString()));
      }
      emit(ReachedLocationSuccess(reachedLocation: response));
    } catch (e) {
      print(e.toString());
      emit(ReachedLocationError(error: e.toString()));
    }
  }
}
