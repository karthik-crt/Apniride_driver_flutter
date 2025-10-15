// Updated model: lib/model/ratings_summary.dart

import 'dart:convert';

RatingsSummary ratingsSummaryFromJson(Map<String, dynamic> json) =>
    RatingsSummary.fromJson(json);

String ratingsSummaryToJson(RatingsSummary object) =>
    jsonEncode(object.toJson());

class RatingsSummary {
  String statusCode;
  String statusMessage;
  Data data;

  RatingsSummary({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  factory RatingsSummary.fromJson(Map<String, dynamic> json) => RatingsSummary(
    statusCode: json["StatusCode"],
    statusMessage: json["StatusMessage"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "StatusCode": statusCode,
    "StatusMessage": statusMessage,
    "data": data.toJson(),
  };
}

class Data {
  double avgRating;
  int totalReviews;
  Map<String, int> distribution;
  List<Feedback> recentFeedback;
  RideSummary rideSummary;

  Data({
    required this.avgRating,
    required this.totalReviews,
    required this.distribution,
    required this.recentFeedback,
    required this.rideSummary,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    avgRating: (json["avg_rating"] as num).toDouble(),
    totalReviews: json["total_reviews"],
    distribution: Map.from(
      json["distribution"],
    ).map((k, v) => MapEntry<String, int>(k, v as int)),
    recentFeedback:
        json["recent_feedback"] == null
            ? []
            : List<Feedback>.from(
              json["recent_feedback"].map((x) => Feedback.fromJson(x)),
            ),
    rideSummary: RideSummary.fromJson(json["ride_summary"]),
  );

  Map<String, dynamic> toJson() => {
    "avg_rating": avgRating,
    "total_reviews": totalReviews,
    "distribution": Map.from(
      distribution,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "recent_feedback": List<dynamic>.from(
      recentFeedback.map((x) => x.toJson()),
    ),
    "ride_summary": rideSummary.toJson(),
  };
}

class Feedback {
  int id;
  int ride;
  int user;
  int driver;
  int stars;
  String feedback;
  DateTime createdAt;
  String userName;
  String driverName;

  Feedback({
    required this.id,
    required this.ride,
    required this.user,
    required this.driver,
    required this.stars,
    required this.feedback,
    required this.createdAt,
    required this.userName,
    required this.driverName,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    id: json["id"],
    ride: json["ride"],
    user: json["user"],
    driver: json["driver"],
    stars: json["stars"],
    feedback: json["feedback"] ?? '',
    createdAt: DateTime.parse(json["created_at"]),
    userName: json["user_name"] ?? 'Unknown',
    driverName: json["driver_name"] ?? 'Unknown',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ride": ride,
    "user": user,
    "driver": driver,
    "stars": stars,
    "feedback": feedback,
    "created_at": createdAt.toIso8601String(),
    "user_name": userName,
    "driver_name": driverName,
  };
}

class RideSummary {
  int totalRides;
  double completionRate;
  String? avgTripTime;
  String topDestination;

  RideSummary({
    required this.totalRides,
    required this.completionRate,
    this.avgTripTime,
    required this.topDestination,
  });

  factory RideSummary.fromJson(Map<String, dynamic> json) => RideSummary(
    totalRides: json["total_rides"],
    completionRate: (json["completion_rate"] as num).toDouble(),
    avgTripTime: json["avg_trip_time"],
    topDestination: json["top_destination"] ?? 'Unknown',
  );

  Map<String, dynamic> toJson() => {
    "total_rides": totalRides,
    "completion_rate": completionRate,
    "avg_trip_time": avgTripTime,
    "top_destination": topDestination,
  };
}
