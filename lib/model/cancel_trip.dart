CancelTrip cancelTripFromJson(Map<String, dynamic> json) =>
    CancelTrip.fromJson(json);

class CancelTrip {
  CancelTrip({
    required this.statusCode,
    required this.statusMessage,
    required this.riderName,
  });
  late final String statusCode;
  late final String statusMessage;
  late final String riderName;

  CancelTrip.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    riderName = json['rider_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['rider_name'] = riderName;
    return _data;
  }
}
