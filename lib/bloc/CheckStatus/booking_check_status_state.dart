import '../../model/booking_status.dart';

abstract class BookingStatusState3 {}

class BookingStatusInitial3 extends BookingStatusState3 {}

class BookingStatusLoading3 extends BookingStatusState3 {}

class BookingStatusSuccess3 extends BookingStatusState3 {
  final BookingStatus bookingStatus;

  BookingStatusSuccess3(this.bookingStatus);

  @override
  List<Object> get props => [bookingStatus];
}

class BookingStatusError3 extends BookingStatusState3 {
  final String error;

  BookingStatusError3(this.error);

  @override
  List<Object> get props => [error];
}
