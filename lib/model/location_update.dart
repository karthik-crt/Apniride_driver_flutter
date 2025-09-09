// LocationUpdate locationUpdateFromJson(Map<String, dynamic> json) =>
//     LocationUpdate.fromJson(json);
//
// class LocationUpdate {
//   LocationUpdate({
//     required this.statusCode,
//     required this.statusMessage,
//     required this.driver,
//   });
//
//   late final String statusCode;
//   late final String statusMessage;
//   late final Driver driver;
//
//   LocationUpdate.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     statusMessage = json['statusMessage'];
//     driver = Driver.fromJson(json['driver']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['statusCode'] = statusCode;
//     _data['statusMessage'] = statusMessage;
//     _data['driver'] = driver.toJson();
//     return _data;
//   }
// }
//
// class Driver {
//   Driver({
//     required this.type,
//     required this.latitude,
//     required this.longitude,
//     required this.driver,
//   });
//
//   late final String type;
//   late final double latitude;
//   late final double longitude;
//   late final Driver driver;
//
//   Driver.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     driver = Driver.fromJson(json['driver']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['type'] = type;
//     _data['latitude'] = latitude;
//     _data['longitude'] = longitude;
//     _data['driver'] = driver.toJson();
//     return _data;
//   }
// }
LocationUpdate locationUpdateFromJson(Map<String, dynamic> json) =>
    LocationUpdate.fromJson(json);

class LocationUpdate {
  LocationUpdate({
    required this.statusCode,
    required this.statusMessage,
    required this.driver,
  });

  final String? statusCode;
  final String? statusMessage;
  final Driver driver;

  factory LocationUpdate.fromJson(Map<String, dynamic> json) {
    return LocationUpdate(
      statusCode: json['statusCode']?.toString(),
      statusMessage: json['statusMessage'] as String?,
      driver: Driver.fromJson(json['driver'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'driver': driver.toJson(),
    };
  }
}

class Driver {
  Driver({
    this.type,
    this.latitude,
    this.longitude,
    this.driver,
    this.id,
    this.username,
  });

  final String? type;
  final double? latitude;
  final double? longitude;
  final Driver? driver;
  final int? id;
  final String? username;

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      type: json['type'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      id: json['id'] as int?,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'driver': driver?.toJson(),
      'id': id,
      'username': username,
    };
  }
}
