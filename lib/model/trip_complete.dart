TripCompleted tripCompletedFromJson(Map<String, dynamic> json) =>
    TripCompleted.fromJson(json);

class TripCompleted {
  TripCompleted({
    required this.statusCode,
    required this.statusMessage,
    required this.ride,
  });

  final String statusCode;
  final String statusMessage;
  final Ride ride;

  factory TripCompleted.fromJson(Map<String, dynamic> json) {
    return TripCompleted(
      statusCode: json['statusCode']?.toString() ?? '',
      statusMessage: json['statusMessage']?.toString() ?? '',
      ride: Ride.fromJson(json['ride'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'ride': ride.toJson(),
    };
  }
}

class Ride {
  Ride({
    required this.id,
    required this.username,
    required this.driverName,
    required this.bookingId,
    required this.pickup,
    required this.drop,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.pickupMode,
    required this.pickupTime,
    required this.distanceKm,
    required this.vehicleType,
    required this.fare,
    required this.fareEstimate,
    required this.driverIncentive,
    required this.customerReward,
    required this.status,
    required this.completed,
    required this.paid,
    required this.createdAt,
    required this.otp,
    this.completedAt,
    this.couponApplied,
    this.rating,
    this.feedback,
    required this.user,
    required this.driver,
    this.assignedDriver,
    required this.rejectedBy,
  });

  final int id;
  final String username;
  final String driverName;
  final String bookingId;
  final String pickup;
  final String drop;
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final String pickupMode;
  final String pickupTime;
  final double distanceKm;
  final String vehicleType;
  final int fare;
  final String fareEstimate;
  final int driverIncentive;
  final CustomerReward customerReward;
  final String status;
  final bool completed;
  final bool paid;
  final String createdAt;
  final String otp;
  final String? completedAt;
  final String? couponApplied;
  final double? rating;
  final String? feedback;
  final int user;
  final int driver;
  final int? assignedDriver;
  final List<dynamic> rejectedBy;

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      username: json['username']?.toString() ?? '',
      driverName: json['driver_name']?.toString() ?? '',
      bookingId: json['booking_id']?.toString() ?? '',
      pickup: json['pickup']?.toString() ?? '',
      drop: json['drop']?.toString() ?? '',
      pickupLat:
          (json['pickup_lat'] is num
              ? json['pickup_lat'].toDouble()
              : double.tryParse(json['pickup_lat'].toString())) ??
          0.0,
      pickupLng:
          (json['pickup_lng'] is num
              ? json['pickup_lng'].toDouble()
              : double.tryParse(json['pickup_lng'].toString())) ??
          0.0,
      dropLat:
          (json['drop_lat'] is num
              ? json['drop_lat'].toDouble()
              : double.tryParse(json['drop_lat'].toString())) ??
          0.0,
      dropLng:
          (json['drop_lng'] is num
              ? json['drop_lng'].toDouble()
              : double.tryParse(json['drop_lng'].toString())) ??
          0.0,
      pickupMode: json['pickup_mode']?.toString() ?? '',
      pickupTime: json['pickup_time']?.toString() ?? '',
      distanceKm:
          (json['distance_km'] is num
              ? json['distance_km'].toDouble()
              : double.tryParse(json['distance_km'].toString())) ??
          0.0,
      vehicleType: json['vehicle_type']?.toString() ?? '',
      fare:
          json['fare'] is int
              ? json['fare']
              : int.tryParse(json['fare'].toString()) ?? 0,
      fareEstimate: json['fare_estimate']?.toString() ?? '',
      driverIncentive:
          json['driver_incentive'] is int
              ? json['driver_incentive']
              : int.tryParse(json['driver_incentive'].toString()) ?? 0,
      customerReward: CustomerReward.fromJson(json['customer_reward'] ?? {}),
      status: json['status']?.toString() ?? '',
      completed: json['completed'] is bool ? json['completed'] : false,
      paid: json['paid'] is bool ? json['paid'] : false,
      createdAt: json['created_at']?.toString() ?? '',
      otp: json['otp']?.toString() ?? '',
      completedAt: json['completed_at']?.toString(),
      couponApplied: json['coupon_applied']?.toString(),
      rating:
          (json['rating'] is num
              ? json['rating'].toDouble()
              : double.tryParse(json['rating'].toString())),
      feedback: json['feedback']?.toString(),
      user:
          json['user'] is int
              ? json['user']
              : int.tryParse(json['user'].toString()) ?? 0,
      driver:
          json['driver'] is int
              ? json['driver']
              : int.tryParse(json['driver'].toString()) ?? 0,
      assignedDriver:
          json['assigned_driver'] is int
              ? json['assigned_driver']
              : int.tryParse(json['assigned_driver'].toString()),
      rejectedBy: List<dynamic>.from(json['rejected_by'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'driver_name': driverName,
      'booking_id': bookingId,
      'pickup': pickup,
      'drop': drop,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'drop_lat': dropLat,
      'drop_lng': dropLng,
      'pickup_mode': pickupMode,
      'pickup_time': pickupTime,
      'distance_km': distanceKm,
      'vehicle_type': vehicleType,
      'fare': fare,
      'fare_estimate': fareEstimate,
      'driver_incentive': driverIncentive,
      'customer_reward': customerReward.toJson(),
      'status': status,
      'completed': completed,
      'paid': paid,
      'created_at': createdAt,
      'otp': otp,
      'completed_at': completedAt,
      'coupon_applied': couponApplied,
      'rating': rating,
      'feedback': feedback,
      'user': user,
      'driver': driver,
      'assigned_driver': assignedDriver,
      'rejected_by': rejectedBy,
    };
  }
}

class CustomerReward {
  CustomerReward();

  factory CustomerReward.fromJson(Map<String, dynamic> json) {
    return CustomerReward();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
