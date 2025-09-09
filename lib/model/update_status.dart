UpdateStatus updateStatusFromJson(Map<String, dynamic> json) =>
    UpdateStatus.fromJson(json);

class UpdateStatus {
  UpdateStatus({
    required this.statusCode,
    required this.message,
    required this.isOnline,
  });

  late final String statusCode;
  late final String message;
  late final bool isOnline;

  UpdateStatus.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] ?? "";
    message = json['message'] ?? "";
    isOnline = json['is_online'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['message'] = message;
    _data['is_online'] = isOnline;
    return _data;
  }
}
