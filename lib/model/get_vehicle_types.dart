GetVehicleTypes getVehicleTypesFromJson(Map<String, dynamic> json) =>
    GetVehicleTypes.fromJson(json);

class GetVehicleTypes {
  GetVehicleTypes({
    required this.statusCode,
    required this.statusMessage,
    required this.vehicleTypes,
  });
  late final String statusCode;
  late final String statusMessage;
  late final List<VehicleTypes> vehicleTypes;

  GetVehicleTypes.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    vehicleTypes =
        List.from(
          json['vehicleTypes'],
        ).map((e) => VehicleTypes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['vehicleTypes'] = vehicleTypes.map((e) => e.toJson()).toList();
    return _data;
  }
}

class VehicleTypes {
  VehicleTypes({
    required this.id,
    required this.vehicleImage,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.perKmRate,
    required this.perMinuteRate,
    required this.seatingCapacity,
    required this.luggageCapacity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String vehicleImage;
  late final String name;
  late final String description;
  late final String baseFare;
  late final String perKmRate;
  late final String perMinuteRate;
  late final int seatingCapacity;
  late final int luggageCapacity;
  late final bool isActive;
  late final String createdAt;
  late final String updatedAt;

  VehicleTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleImage = json['vehicleImage'] ?? "";
    name = json['name'];
    description = json['description'];
    baseFare = json['base_fare'];
    perKmRate = json['per_km_rate'];
    perMinuteRate = json['per_minute_rate'];
    seatingCapacity = json['seating_capacity'];
    luggageCapacity = json['luggage_capacity'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['vehicleImage'] = vehicleImage;
    _data['name'] = name;
    _data['description'] = description;
    _data['base_fare'] = baseFare;
    _data['per_km_rate'] = perKmRate;
    _data['per_minute_rate'] = perMinuteRate;
    _data['seating_capacity'] = seatingCapacity;
    _data['luggage_capacity'] = luggageCapacity;
    _data['is_active'] = isActive;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
