import 'package:apni_ride_user/bloc/UpdateStatus/update_status_state.dart';
import 'package:apni_ride_user/utills/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/update_status.dart';

class UpdateStatusCubit extends Cubit<UpdateStatusState> {
  final ApiService apiService;

  UpdateStatusCubit(this.apiService) : super(UpdateStatusInitial());

  Future<void> updateStatus(bool value, BuildContext context) async {
    emit(UpdateStatusLoading());
    try {
      final data = {"is_online": value};
      final status = await apiService.updateStatus(data);
      print("status $status");
      emit(UpdateStatusSuccess(status));
    } catch (e) {
      print("Update Status Error: $e");
      emit(UpdateStatusError(e.toString()));
    }
  }

  Future<UpdateStatus> getUpdateStatus() async {
    try {
      final status = await apiService.getUpdateStatus();
      print("status $status");
      emit(UpdateStatusSuccess(status));
      return status;
    } catch (e) {
      print("Get Update Status Error: $e");
      emit(UpdateStatusError(e.toString()));
      rethrow;
    }
  }
}
