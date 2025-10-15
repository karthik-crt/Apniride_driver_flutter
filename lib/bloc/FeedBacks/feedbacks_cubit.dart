import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';
import 'feedbacks_state.dart';

class RatingsCubit extends Cubit<RatingsState> {
  final ApiService apiService;

  RatingsCubit(this.apiService) : super(RatingsInitial());

  Future<void> getRatings(BuildContext context) async {
    emit(RatingsLoading());
    try {
      final ratingsSummary = await apiService.getRatingsSummary();
      print("Ratings Summary fetched: ${ratingsSummary.statusMessage}");
      if (ratingsSummary.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ratingsSummary.statusMessage)));
        emit(RatingsError(ratingsSummary.statusMessage));
      } else {
        emit(RatingsSuccess(ratingsSummary));
      }
    } catch (e) {
      print("Error fetching ratings summary: $e");
      emit(RatingsError(e.toString()));
    }
  }
}
