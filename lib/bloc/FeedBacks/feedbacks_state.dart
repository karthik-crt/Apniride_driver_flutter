// Replace the provided FeedbacksState with this (renamed to ratings_state.dart)

import '../../model/feedback_data.dart';

abstract class RatingsState {}

class RatingsInitial extends RatingsState {}

class RatingsLoading extends RatingsState {}

class RatingsSuccess extends RatingsState {
  final RatingsSummary ratingsSummary;

  RatingsSuccess(this.ratingsSummary);
}

class RatingsError extends RatingsState {
  final String message;

  RatingsError(this.message);
}
