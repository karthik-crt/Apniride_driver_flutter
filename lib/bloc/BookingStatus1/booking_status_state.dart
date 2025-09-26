import '../../model/booking_status.dart';

abstract class BookingStatusState1 {}

class BookingStatusInitial1 extends BookingStatusState1 {}

class BookingStatusLoading1 extends BookingStatusState1 {}

class BookingStatusSuccess1 extends BookingStatusState1 {
  final BookingStatus bookingStatus;

  BookingStatusSuccess1(this.bookingStatus);

  @override
  List<Object> get props => [bookingStatus];
}

class BookingStatusError1 extends BookingStatusState1 {
  final String error;

  BookingStatusError1(this.error);

  @override
  List<Object> get props => [error];
}
