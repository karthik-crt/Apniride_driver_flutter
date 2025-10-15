import 'dart:convert';

RidesHistory ridesHistoryFromJson(Map<String, dynamic> json) =>
    RidesHistory.fromJson(json);

class RidesHistory {
  RidesHistory({
    required this.statusCode,
    required this.message,
    required this.count,
    required this.rides,
  });

  final String statusCode;
  final String message;
  final int count;
  final List<Ride> rides;

  factory RidesHistory.fromJson(Map<String, dynamic> json) {
    return RidesHistory(
      statusCode: json['StatusCode'] ?? '',
      message: json['Message'] ?? '',
      count: json['count'] ?? 0,
      rides: List<Ride>.from(json['rides']?.map((x) => Ride.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['Message'] = message;
    data['count'] = count;
    data['rides'] = rides.map((e) => e.toJson()).toList();
    return data;
  }
}

class Ride {
  Ride({
    required this.id,
    required this.username,
    required this.userNumber,
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
    required this.driverToPickup,
    required this.expectedEarnings,
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
    required this.paymentType,
  });

  final int id;
  final String username;
  final String userNumber;
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
  final double fare;
  final String fareEstimate;
  final double driverToPickup;
  final String expectedEarnings;

  final double driverIncentive;
  final CustomerReward customerReward;
  final String status;
  final bool completed;
  final bool paid;
  final String createdAt;
  final String otp;
  final String? completedAt;
  final bool? couponApplied;
  final int? rating;
  final String? feedback;
  final int user;
  final int driver;
  final int? assignedDriver;
  final List<dynamic> rejectedBy;
  final String paymentType;

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      userNumber: json['usernumber'] ?? '',
      driverName: json['driver_name'] ?? '',
      bookingId: json['booking_id'] ?? '',
      pickup: json['pickup'] ?? '',
      drop: json['drop'] ?? '',
      pickupLat: (json['pickup_lat'] ?? 0.0).toDouble(),
      pickupLng: (json['pickup_lng'] ?? 0.0).toDouble(),
      dropLat: (json['drop_lat'] ?? 0.0).toDouble(),
      dropLng: (json['drop_lng'] ?? 0.0).toDouble(),
      pickupMode: json['pickup_mode'] ?? '',
      pickupTime: json['pickup_time'] ?? '',
      distanceKm: (json['distance_km'] ?? 0.0).toDouble(),
      vehicleType: json['vehicle_type'] ?? '',
      fare: (json['fare'] ?? 0.0).toDouble(),
      fareEstimate: json['fare_estimate'] ?? '',
      driverToPickup: (json['driver_to_pickup_km'] ?? 0.0).toDouble(),
      expectedEarnings: json['driver_earnings'] ?? '',
      driverIncentive: (json['driver_incentive'] ?? 0.0).toDouble(),
      customerReward: CustomerReward.fromJson(json['customer_reward'] ?? {}),
      status: json['status'] ?? '',
      completed: json['completed'] ?? false,
      paid: json['paid'] ?? false,
      createdAt: json['created_at'] ?? '',
      otp: json['otp'] ?? '',
      completedAt: json['completed_at'],
      couponApplied: json['coupon_applied'],
      rating: json['rating'],
      feedback: json['feedback'],
      user: json['user'] ?? 0,
      driver: json['driver'] ?? 0,
      assignedDriver: json['assigned_driver'],
      rejectedBy: List<dynamic>.from(json['rejected_by'] ?? []),
      paymentType: json['payment_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['usernumber'] = userNumber;
    data['driver_name'] = driverName;
    data['booking_id'] = bookingId;
    data['pickup'] = pickup;
    data['drop'] = drop;
    data['pickup_lat'] = pickupLat;
    data['pickup_lng'] = pickupLng;
    data['drop_lat'] = dropLat;
    data['drop_lng'] = dropLng;
    data['pickup_mode'] = pickupMode;
    data['pickup_time'] = pickupTime;
    data['distance_km'] = distanceKm;
    data['vehicle_type'] = vehicleType;
    data['fare'] = fare;
    data['fare_estimate'] = fareEstimate;
    data['driver_to_pickup_km'] = driverToPickup;
    data['driver_earnings'] = expectedEarnings;

    data['driver_incentive'] = driverIncentive;
    data['customer_reward'] = customerReward.toJson();
    data['status'] = status;
    data['completed'] = completed;
    data['paid'] = paid;
    data['created_at'] = createdAt;
    data['otp'] = otp;
    data['completed_at'] = completedAt;
    data['coupon_applied'] = couponApplied;
    data['rating'] = rating;
    data['feedback'] = feedback;
    data['user'] = user;
    data['driver'] = driver;
    data['assigned_driver'] = assignedDriver;
    data['rejected_by'] = rejectedBy;
    data['payment_type'] = paymentType;
    return data;
  }
}

class CustomerReward {
  CustomerReward({this.amount, this.description});

  final int? amount;
  final String? description;

  factory CustomerReward.fromJson(Map<String, dynamic> json) {
    return CustomerReward(
      amount: json['amount'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['amount'] = amount;
    data['description'] = description;
    return data;
  }
}
