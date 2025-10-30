import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utills/api_service.dart';
import 'booking_check_status_state.dart';

class BookingStatusCubit3 extends Cubit<BookingStatusState3> {
  final ApiService apiService;

  BookingStatusCubit3(this.apiService) : super(BookingStatusInitial3());

  Future<void> fetchBookingStatus(
    BuildContext context,
    String bookingId,
  ) async {
    emit(BookingStatusLoading3());
    try {
      final bookingStatus = await apiService.bookingStatus(bookingId);
      print("bookingStatus ${bookingStatus.data.status}");
      if (bookingStatus.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(bookingStatus.StatusMessage)));
        emit(BookingStatusError3(bookingStatus.StatusMessage));
      } else {
        emit(BookingStatusSuccess3(bookingStatus));
      }
    } catch (e) {
      emit(BookingStatusError3(e.toString()));
    }
  }

  void reset() {
    emit(BookingStatusInitial3());
    print("🔄 BookingStatusCubit3 RESET - Clean State");
  }
}
