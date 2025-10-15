import 'package:apni_ride_user/bloc/WalletHistory/wallet_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';

class WalletHistoryCubit extends Cubit<WalletHistoryState> {
  final ApiService apiService;

  WalletHistoryCubit(this.apiService) : super(WalletHistoryInitial());

  Future<void> getWalletHistory() async {
    emit(WalletHistoryLoading());
    try {
      final walletData = await apiService.getWalletHistory();
      print("status $walletData");

      if (walletData.StatusCode != "1") {
        emit(WalletHistoryError(walletData.StatusMessage));
      } else {
        emit(WalletHistorySuccess(walletData));
      }
    } catch (e) {
      print("incentives error $e");
      emit(WalletHistoryError(e.toString()));
    }
  }
}
