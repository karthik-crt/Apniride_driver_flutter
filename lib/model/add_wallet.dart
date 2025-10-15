AddWallet addWalletFromJson(Map<String, dynamic> json) =>
    AddWallet.fromJson(json);

class AddWallet {
  AddWallet({
    required this.StatusCode,
    required this.message,
    required this.balance,
  });
  late final String StatusCode;
  late final String message;
  late final num balance;

  AddWallet.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    message = json['message'];
    balance = json['balance'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['message'] = message;
    _data['balance'] = balance;
    return _data;
  }
}
