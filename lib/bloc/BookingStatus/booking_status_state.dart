import '../../model/booking_status.dart';

abstract class BookingStatusState {}

class BookingStatusInitial extends BookingStatusState {}

class BookingStatusLoading extends BookingStatusState {}

class BookingStatusSuccess extends BookingStatusState {
  final BookingStatus bookingStatus;

  BookingStatusSuccess(this.bookingStatus);

  @override
  List<Object> get props => [bookingStatus];
}

class BookingStatusError extends BookingStatusState {
  final String error;

  BookingStatusError(this.error);

  @override
  List<Object> get props => [error];
}
