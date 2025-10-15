import 'package:apni_ride_user/bloc/RejectRide/reject_ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';

class RejectRideCubit extends Cubit<RejectRideState> {
  final ApiService apiService;

  RejectRideCubit(this.apiService) : super(RejectRideInitial());

  Future<void> rejectingRide(String rideId) async {
    emit(RejectRideLoading());
    try {
      final reject = await apiService.rejectRide(rideId);
      print("reject $reject");

      if (reject.statusCode != "1") {
        emit(RejectRideError(reject.statusMessage));
      } else {
        emit(RejectRideSuccess(reject));
      }
    } catch (e) {
      print("Get vehicle error: $e");
      emit(RejectRideError(e.toString()));
    }
  }
}
