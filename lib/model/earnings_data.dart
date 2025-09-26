Earnings earningsFromJson(Map<String, dynamic> json) => Earnings.fromJson(json);

class Earnings {
  Earnings({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  late final String statusCode;
  late final String statusMessage;
  late final List<Data> data;

  Earnings.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    statusMessage = json['StatusMessage'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = statusCode;
    _data['StatusMessage'] = statusMessage;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.period,
    required this.totalEarnings,
    required this.totalRides,
  });

  late final String period;
  late final double totalEarnings; // Changed from int to double
  late final int totalRides;

  Data.fromJson(Map<String, dynamic> json) {
    period = json['period'] ?? "";
    totalEarnings =
        (json['total_earnings'] is int)
            ? (json['total_earnings'] as int).toDouble()
            : (json['total_earnings'] as double?) ??
                0.0; // Handle int or double
    totalRides = json['total_rides'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['period'] = period;
    _data['total_earnings'] = totalEarnings;
    _data['total_rides'] = totalRides;
    return _data;
  }
}
