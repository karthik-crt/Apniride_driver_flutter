import '../../model/rides_history.dart';

abstract class RidesHistoryState {}

class RidesHistoryInitial extends RidesHistoryState {}

class RidesHistoryLoading extends RidesHistoryState {}

class RidesHistorySuccess extends RidesHistoryState {
  final RidesHistory ridesHistory;

  RidesHistorySuccess(this.ridesHistory);
}

class RidesHistoryError extends RidesHistoryState {
  final String message;

  RidesHistoryError(this.message);
}
