AcceptRide acceptRideFromJson(Map<String, dynamic> json) =>
    AcceptRide.fromJson(json);

class AcceptRide {
  AcceptRide({required this.statusCode, required this.statusMessage});

  late final String statusCode;
  late final String statusMessage;

  AcceptRide.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    return _data;
  }
}
