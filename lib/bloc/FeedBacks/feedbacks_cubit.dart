import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';
import 'feedbacks_state.dart';

class FeedbacksCubit extends Cubit<FeedbacksState> {
  final ApiService apiService;

  FeedbacksCubit(this.apiService) : super(FeedbacksInitial());

  Future<void> getFeedbacks(BuildContext context) async {
    emit(FeedbacksLoading());
    try {
      final ridesHistory = await apiService.getRidesHistory();
      print("RidesHistory fetched: ${ridesHistory.message}");
      if (ridesHistory.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ridesHistory.message)));
        emit(FeedbacksError(ridesHistory.message));
      } else {
        emit(FeedbacksSuccess(ridesHistory));
      }
    } catch (e) {
      print("Error fetching rides history: $e");
      emit(FeedbacksError(e.toString()));
    }
  }
}
