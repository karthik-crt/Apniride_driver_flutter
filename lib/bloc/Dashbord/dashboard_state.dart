import '../../model/dashboard_data.dart';
import '../../model/rides_history.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final Dashboard dashboard;

  DashboardSuccess(this.dashboard);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
