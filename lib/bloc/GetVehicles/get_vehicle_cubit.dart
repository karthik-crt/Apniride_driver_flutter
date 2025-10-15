import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';
import 'get_vehicle_state.dart';

class GetVehicleCubit extends Cubit<GetVehicleState> {
  final ApiService apiService;

  GetVehicleCubit(this.apiService) : super(GetVehicleInitial());

  Future<void> getVehicleTypes() async {
    emit(GetVehicleLoading());
    try {
      final status = await apiService.getVehicleTypes();
      print("status $status");

      if (status.statusCode != "1") {
        emit(GetVehicleError(status.statusMessage));
      } else {
        emit(GetVehicleSuccess(status));
      }
    } catch (e) {
      print("Get vehicle error: $e");
      emit(GetVehicleError(e.toString()));
    }
  }
}
