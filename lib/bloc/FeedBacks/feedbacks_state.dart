import '../../model/rides_history.dart';

abstract class FeedbacksState {}

class FeedbacksInitial extends FeedbacksState {}

class FeedbacksLoading extends FeedbacksState {}

class FeedbacksSuccess extends FeedbacksState {
  final RidesHistory ridesHistory;

  FeedbacksSuccess(this.ridesHistory);
}

class FeedbacksError extends FeedbacksState {
  final String message;

  FeedbacksError(this.message);
}
