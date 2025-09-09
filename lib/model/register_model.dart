RegisterData registerDataFromJson(Map<String, dynamic> json) =>
    RegisterData.fromJson(json);

class RegisterData {
  RegisterData({
    required this.statusCode,
    required this.statusMessage,
    required this.isOldUser,
    required this.access,
    required this.refresh,
    required this.id,
    required this.password,
    this.lastLogin,
    required this.isSuperuser,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    required this.isDriver,
    required this.email,
    required this.mobile,
    required this.isUser,
    this.drivingLicense,
    this.rcBook,
    this.aadhaar,
    this.panCard,
    required this.vehicleType,
    required this.model,
    required this.plateNumber,
    required this.state,
    required this.approvalState,
    required this.groups,
    required this.userPermissions,
  });

  late final String statusCode;
  late final String statusMessage;
  late final bool isOldUser;
  late final String access;
  late final String refresh;
  late final int id;
  late final String password;
  late final Null lastLogin;
  late final bool isSuperuser;
  late final String username;
  late final String firstName;
  late final String lastName;
  late final bool isStaff;
  late final bool isActive;
  late final String dateJoined;
  late final int isDriver;
  late final String email;
  late final String mobile;
  late final String fcmToken;
  late final int isUser;
  late final Null drivingLicense;
  late final Null rcBook;
  late final Null aadhaar;
  late final Null panCard;
  late final String vehicleType;
  late final String model;
  late final String plateNumber;
  late final String state;
  late final String approvalState;
  late final List<dynamic> groups;
  late final List<dynamic> userPermissions;

  RegisterData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    isOldUser = json['is_oldUser'];
    access = json['access'];
    refresh = json['refresh'];
    id = json['id'];
    password = json['password'];
    lastLogin = null;
    isSuperuser = json['is_superuser'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    isDriver = json['is_driver'];
    email = json['email'];
    mobile = json['mobile'];
    fcmToken = json['fcm_token'];
    isUser = json['is_user'];
    drivingLicense = null;
    rcBook = null;
    aadhaar = null;
    panCard = null;
    vehicleType = json['vehicle_type'];
    model = json['model'];
    plateNumber = json['plate_number'];
    state = json['state'];
    approvalState = json['approval_state'];
    groups = List.castFrom<dynamic, dynamic>(json['groups']);
    userPermissions = List.castFrom<dynamic, dynamic>(json['user_permissions']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['is_oldUser'] = isOldUser;
    _data['access'] = access;
    _data['refresh'] = refresh;
    _data['id'] = id;
    _data['password'] = password;
    _data['last_login'] = lastLogin;
    _data['is_superuser'] = isSuperuser;
    _data['username'] = username;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['is_staff'] = isStaff;
    _data['is_active'] = isActive;
    _data['date_joined'] = dateJoined;
    _data['is_driver'] = isDriver;
    _data['email'] = email;
    _data['mobile'] = mobile;
    _data['is_user'] = isUser;
    _data['driving_license'] = drivingLicense;
    _data['rc_book'] = rcBook;
    _data['aadhaar'] = aadhaar;
    _data['pan_card'] = panCard;
    _data['vehicle_type'] = vehicleType;
    _data['model'] = model;
    _data['plate_number'] = plateNumber;
    _data['state'] = state;
    _data['approval_state'] = approvalState;
    _data['groups'] = groups;
    _data['user_permissions'] = userPermissions;
    return _data;
  }
}
