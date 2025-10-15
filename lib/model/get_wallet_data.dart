GetWallet getWalletFromJson(Map<String, dynamic> json) =>
    GetWallet.fromJson(json);

class GetWallet {
  GetWallet({
    required this.StatusCode,
    required this.StatusMessage,
    required this.data,
  });
  late final String StatusCode;
  late final String StatusMessage;
  late final Data data;

  GetWallet.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    StatusMessage = json['StatusMessage'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['StatusMessage'] = StatusMessage;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.driver,
    required this.balance,
    required this.updatedAt,
  });
  late final int id;
  late final int driver;
  late final String balance;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driver = json['driver'];
    balance = json['balance'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['driver'] = driver;
    _data['balance'] = balance;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
