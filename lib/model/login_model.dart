LoginData loginDataFromJson(Map<String, dynamic> json) =>
    LoginData.fromJson(json);

class LoginData {
  LoginData({
    required this.statusCode,
    required this.statusMessage,
    required this.isOldUser,
    required this.access,
    required this.id,
  });

  late final String statusCode;
  late final String statusMessage;
  late final bool isOldUser;
  late final String access;
  late final int id;

  LoginData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    isOldUser = json['is_oldUser'];
    access = json['access'] ?? "";
    id = json['id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['is_oldUser'] = isOldUser;
    _data['access'] = access;
    _data['id'] = id;
    return _data;
  }
}
