GetProfile getProfileFromJson(Map<String, dynamic> json) =>
    GetProfile.fromJson(json);

class GetProfile {
  GetProfile({
    required this.StatusCode,
    required this.statusMessage,
    required this.data,
  });

  late final int StatusCode;
  late final String statusMessage;
  late final Data data;

  GetProfile.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    statusMessage = json['statusMessage'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['statusMessage'] = statusMessage;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.username,
    required this.profilePhoto,
    required this.mobile,
    required this.emergencyContactNumber,
    required this.approvalState,
    required this.preferredPaymentMethod,
  });

  late final String username;
  late final String profilePhoto;
  late final String mobile;
  late final String emergencyContactNumber;
  late final String approvalState;
  late final String preferredPaymentMethod;

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'] ?? "";
    profilePhoto = json['profile_photo'] ?? "";
    mobile = json['mobile'] ?? "";
    emergencyContactNumber = json['emergency_contact_number'] ?? "";
    approvalState = json['approval_state'] ?? "";
    preferredPaymentMethod = json['preferred_payment_method'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['profile_photo'] = profilePhoto;
    _data['mobile'] = mobile;
    _data['emergency_contact_number'] = emergencyContactNumber;
    _data['approval_state'] = approvalState;
    _data['preferred_payment_method'] = preferredPaymentMethod;
    return _data;
  }
}
