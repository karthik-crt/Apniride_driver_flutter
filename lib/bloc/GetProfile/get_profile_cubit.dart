import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';
import 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  final ApiService apiService;

  GetProfileCubit(this.apiService) : super(GetProfileInitial());

  Future<void> getUpdateStatus() async {
    try {
      final status = await apiService.getProfile();
      print("status $status");

      if (status.StatusCode != 1) {
        emit(GetProfileError(status.statusMessage));
      } else {
        emit(GetProfileSuccess(status));
      }
    } catch (e) {
      print("Get Profile error: $e");
      emit(GetProfileError(e.toString()));
    }
  }
}
