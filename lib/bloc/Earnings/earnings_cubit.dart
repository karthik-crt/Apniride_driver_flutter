import 'package:apni_ride_user/bloc/UpdateStatus/update_status_state.dart';
import 'package:apni_ride_user/utills/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/update_status.dart';
import 'earnings_state.dart';

class EarningsCubit extends Cubit<EarningsState> {
  final ApiService apiService;

  EarningsCubit(this.apiService) : super(EarningsInitial());

  Future<void> getEarningsStatus() async {
    try {
      final status = await apiService.getEarnings();
      print("status $status");
      emit(EarningsSuccess(status));
    } catch (e) {
      print("Get Update Status Error: $e");
      emit(EarningsError(e.toString()));
    }
  }
}
