RejectRide rejectRideFromJson(Map<String, dynamic> json) =>
    RejectRide.fromJson(json);

class RejectRide {
  RejectRide({
    required this.statusCode,
    required this.statusMessage,
    required this.rejectionsToday,
    required this.suspended,
    required this.suspendedUntil,
  });
  late final String statusCode;
  late final String statusMessage;
  late final int rejectionsToday;
  late final bool suspended;
  late final String suspendedUntil;

  RejectRide.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    rejectionsToday = json['rejections_today'] ?? 0;
    suspended = json['suspended'];
    suspendedUntil = json['suspended_until'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['rejections_today'] = rejectionsToday;
    _data['suspended'] = suspended;
    _data['suspended_until'] = suspendedUntil;
    return _data;
  }
}
