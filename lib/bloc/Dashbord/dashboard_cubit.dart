import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/dashboard_data.dart';
import '../../utills/api_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ApiService apiService;

  DashboardCubit(this.apiService) : super(DashboardInitial());

  Future<void> getDashboardDetails(BuildContext context) async {
    emit(DashboardLoading());
    try {
      final dashboard = await apiService.getDashboardData();
      print("Dashboard fetched: ${dashboard.statusMessage}");
      if (dashboard.statusCode != 1) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(dashboard.statusMessage)));
        emit(DashboardError(dashboard.statusMessage));
      } else {
        emit(DashboardSuccess(dashboard));
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
      emit(DashboardError(e.toString()));
    }
  }
}
