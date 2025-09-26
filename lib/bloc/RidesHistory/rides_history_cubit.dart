import 'package:apni_ride_user/Bloc/RidesHistory/rides_history_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';

class RidesHistoryCubit extends Cubit<RidesHistoryState> {
  final ApiService apiService;

  RidesHistoryCubit(this.apiService) : super(RidesHistoryInitial());

  Future<void> fetchRidesHistory(BuildContext context) async {
    emit(RidesHistoryLoading());
    try {
      final ridesHistory = await apiService.getRidesHistory();
      print("RidesHistory fetched: ${ridesHistory.message}");
      if (ridesHistory.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ridesHistory.message)));
        emit(RidesHistoryError(ridesHistory.message));
      } else {
        emit(RidesHistorySuccess(ridesHistory));
      }
    } catch (e) {
      print("Error fetching rides history: $e");
      emit(RidesHistoryError(e.toString()));
    }
  }
}
