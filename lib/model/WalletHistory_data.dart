WalletHistory walletHistoryFromJson(Map<String, dynamic> json) =>
    WalletHistory.fromJson(json);

class WalletHistory {
  WalletHistory({
    required this.StatusCode,
    required this.StatusMessage,
    required this.data,
  });

  late final String StatusCode;
  late final String StatusMessage;
  late final Data data;

  WalletHistory.fromJson(Map<String, dynamic> json) {
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
    required this.driver,
    required this.currentBalance,
    required this.transactions,
  });

  late final String driver;
  late final num currentBalance;
  late final List<Transactions> transactions;

  Data.fromJson(Map<String, dynamic> json) {
    driver = json['driver'];
    currentBalance = json['current_balance'];
    transactions =
        List.from(
          json['transactions'],
        ).map((e) => Transactions.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['driver'] = driver;
    _data['current_balance'] = currentBalance;
    _data['transactions'] = transactions.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Transactions {
  Transactions({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.balanceAfter,
    required this.createdAt,
    required this.rideId,
  });

  late final int id;
  late final String transactionType;
  late final String amount;
  late final String description;
  late final String balanceAfter;
  late final String createdAt;
  late final String rideId;

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionType = json['transaction_type'];
    amount = json['amount'];
    description = json['description'];
    balanceAfter = json['balance_after'];
    createdAt = json['created_at'];
    rideId = json['ride_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['transaction_type'] = transactionType;
    _data['amount'] = amount;
    _data['description'] = description;
    _data['balance_after'] = balanceAfter;
    _data['created_at'] = createdAt;
    _data['ride_id'] = rideId;
    return _data;
  }
}
