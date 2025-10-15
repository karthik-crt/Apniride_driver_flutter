import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';
import 'incentives_state.dart';

class IncentivesCubit extends Cubit<IncentivesState> {
  final ApiService apiService;

  IncentivesCubit(this.apiService) : super(IncentivesInitial());

  Future<void> getIncentives() async {
    emit(IncentivesLoading());
    try {
      final incentives = await apiService.getDriverIncentives();
      print("status $incentives");

      if (incentives.statusCode != "1") {
        emit(IncentivesError(incentives.statusMessage));
      } else {
        emit(IncentivesSuccess(incentives));
      }
    } catch (e) {
      print("incentives error $e");
      emit(IncentivesError(e.toString()));
    }
  }
}
