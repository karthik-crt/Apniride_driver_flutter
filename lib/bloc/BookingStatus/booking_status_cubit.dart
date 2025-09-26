import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utills/api_service.dart';
import 'booking_status_state.dart';

class BookingStatusCubit extends Cubit<BookingStatusState> {
  final ApiService apiService;

  BookingStatusCubit(this.apiService) : super(BookingStatusInitial());

  Future<void> fetchBookingStatus(
    BuildContext context,
    String bookingId,
  ) async {
    emit(BookingStatusLoading());
    try {
      final bookingStatus = await apiService.bookingStatus(bookingId);
      print("bookingStatus ${bookingStatus.data.status}");
      if (bookingStatus.statusCode != '1') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(bookingStatus.StatusMessage)));
        emit(BookingStatusError(bookingStatus.StatusMessage));
      } else {
        emit(BookingStatusSuccess(bookingStatus));
      }
    } catch (e) {
      emit(BookingStatusError(e.toString()));
    }
  }
}
