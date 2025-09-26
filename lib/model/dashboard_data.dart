Dashboard dashboardFromJson(Map<String, dynamic> json) =>
    Dashboard.fromJson(json);

// class Dashboard {
//   Dashboard({
//     required this.StatusCode,
//     required this.StatusMessage,
//     required this.data,
//   });
//   late final int StatusCode;
//   late final String StatusMessage;
//   late final Data data;
//
//   Dashboard.fromJson(Map<String, dynamic> json) {
//     StatusCode = json['StatusCode'];
//     StatusMessage = json['StatusMessage'];
//     data = Data.fromJson(json['data']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['StatusCode'] = StatusCode;
//     _data['StatusMessage'] = StatusMessage;
//     _data['data'] = data.toJson();
//     return _data;
//   }
// }
//
// class Data {
//   Data({
//     required this.todayEarnings,
//     required this.averageRating,
//     required this.tripsToday,
//   });
//   late final int todayEarnings;
//   late final int averageRating;
//   late final int tripsToday;
//
//   Data.fromJson(Map<String, dynamic> json) {
//     todayEarnings = json['today_earnings'];
//     averageRating = json['average_rating'];
//     tripsToday = json['trips_today'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['today_earnings'] = todayEarnings;
//     _data['average_rating'] = averageRating;
//     _data['trips_today'] = tripsToday;
//     return _data;
//   }
// }
class Dashboard {
  Dashboard({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  final int statusCode;
  final String statusMessage;
  final Data data;

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      statusCode: json['StatusCode'] as int? ?? 0,
      statusMessage: json['StatusMessage'] as String? ?? '',
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusCode': statusCode,
      'StatusMessage': statusMessage,
      'data': data.toJson(),
    };
  }
}

class Data {
  Data({
    required this.todayEarnings,
    required this.averageRating,
    required this.tripsToday,
  });

  final double todayEarnings;
  final double averageRating;
  final int tripsToday;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      todayEarnings: (json['today_earnings'] as num?)?.toDouble() ?? 0.0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      tripsToday: json['trips_today'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_earnings': todayEarnings,
      'average_rating': averageRating,
      'trips_today': tripsToday,
    };
  }
}
