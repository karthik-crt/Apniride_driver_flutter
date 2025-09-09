UpdateToken updateTokenFromJson(Map<String, dynamic> json) =>
    UpdateToken.fromJson(json);

class UpdateToken {
  UpdateToken({required this.statusCode, required this.statusMessage});
  late final String statusCode;
  late final String statusMessage;

  UpdateToken.fromJson(Map<String, dynamic> json) {
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
