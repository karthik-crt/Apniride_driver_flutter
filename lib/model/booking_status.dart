BookingStatus bookingStatusFromJson(Map<String, dynamic> json) =>
    BookingStatus.fromJson(json);

class BookingStatus {
  BookingStatus({
    required this.statusCode,
    required this.StatusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String StatusMessage;
  late final Data data;

  BookingStatus.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] ?? "";
    StatusMessage = json['StatusMessage'] ?? "";
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['StatusMessage'] = StatusMessage;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
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

  Data.fromJson(Map<String, dynamic> json) {
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
    otp = json['otp'] ?? "";
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
