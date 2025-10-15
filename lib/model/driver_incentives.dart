DriverIncentives driverIncentivesFromJson(Map<String, dynamic> json) =>
    DriverIncentives.fromJson(json);

class DriverIncentives {
  DriverIncentives({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  final String statusCode;
  final String statusMessage;
  final List<Data> data;

  factory DriverIncentives.fromJson(Map<String, dynamic> json) {
    return DriverIncentives(
      statusCode: json['StatusCode']?.toString() ?? '',
      statusMessage: json['StatusMessage']?.toString() ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusCode': statusCode,
      'StatusMessage': statusMessage,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Data {
  Data({
    required this.rideType,
    required this.minRides,
    required this.distance,
    required this.driverIncentive,
    required this.details,
    required this.ridesCompleted,
    required this.travelledDistance,
    required this.progressPercent,
    required this.earned,
  });

  final String rideType;
  final String minRides;
  final String distance;
  final double driverIncentive;
  final String details;
  final int ridesCompleted;
  final double travelledDistance;
  final double progressPercent;
  final bool earned;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      rideType: json['ride_type']?.toString() ?? '',
      minRides: json['min_rides']?.toString() ?? 'N/A',
      distance: json['distance']?.toString() ?? 'N/A',
      driverIncentive: _parseDouble(json['driver_incentive']) ?? 0.0,
      details: json['details']?.toString() ?? '',
      ridesCompleted: _parseInt(json['rides_completed']) ?? 0,
      travelledDistance: _parseDouble(json['travelled_distance']) ?? 0.0,
      progressPercent: _parseDouble(json['progress_percent']) ?? 0.0,
      earned: json['earned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_type': rideType,
      'min_rides': minRides,
      'distance': distance,
      'driver_incentive': driverIncentive,
      'details': details,
      'rides_completed': ridesCompleted,
      'travelled_distance': travelledDistance,
      'progress_percent': progressPercent,
      'earned': earned,
    };
  }

  // Helper method to parse dynamic values to double
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null; // Handle "N/A" or invalid strings
      }
    }
    return null;
  }

  // Helper method to parse dynamic values to int
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return null; // Handle "N/A" or invalid strings
      }
    }
    return null;
  }
}
