StartTrip startTripFromJson(Map<String, dynamic> json) =>
    StartTrip.fromJson(json);

class StartTrip {
  StartTrip({
    required this.StatusCode,
    required this.message,
    required this.ride,
  });
  late final int StatusCode;
  late final String message;
  late final Ride ride;

  StartTrip.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    message = json['message'];
    ride = Ride.fromJson(json['ride']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['message'] = message;
    _data['ride'] = ride.toJson();
    return _data;
  }
}

class Ride {
  Ride({
    required this.bookingId,
    required this.status,
    required this.pickup,
    required this.drop,
    required this.pickupTime,
    required this.driverName,
    required this.driverNumber,
    required this.vechicleName,
    required this.driverPhoto,
    required this.vehicleNumber,
    required this.otp,
    required this.fare,
    required this.completed,
    required this.paid,
  });
  late final String bookingId;
  late final String status;
  late final String pickup;
  late final String drop;
  late final String pickupTime;
  late final String driverName;
  late final String driverNumber;
  late final String vechicleName;
  late final String driverPhoto;
  late final String vehicleNumber;
  late final String otp;
  late final double fare;
  late final bool completed;
  late final bool paid;

  Ride.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'] ?? "";
    status = json['status'] ?? "";
    pickup = json['pickup'] ?? "";
    drop = json['drop'] ?? "";
    pickupTime = json['pickup_time'] ?? "";
    driverName = json['driver_name'] ?? "";
    driverNumber = json['driver_number'] ?? "";
    vechicleName = json['vechicle_name'] ?? "";
    driverPhoto = json['driver_photo'] ?? "";
    vehicleNumber = json['vehicle_number'] ?? "";
    otp = json['otp'];
    fare = json['fare'];
    completed = json['completed'];
    paid = json['paid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['booking_id'] = bookingId;
    _data['status'] = status;
    _data['pickup'] = pickup;
    _data['drop'] = drop;
    _data['pickup_time'] = pickupTime;
    _data['driver_name'] = driverName;
    _data['driver_number'] = driverNumber;
    _data['vechicle_name'] = vechicleName;
    _data['driver_photo'] = driverPhoto;
    _data['vehicle_number'] = vehicleNumber;
    _data['otp'] = otp;
    _data['fare'] = fare;
    _data['completed'] = completed;
    _data['paid'] = paid;
    return _data;
  }
}
