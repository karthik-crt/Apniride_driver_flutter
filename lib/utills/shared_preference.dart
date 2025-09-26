import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  // Sets
  static Future<bool> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  // Gets
  static bool? getBool(String key) => _prefs.getBool(key);

  static double? getDouble(String key) => _prefs.getDouble(key);

  static int? getInt(String key) => _prefs.getInt(key);

  static String? getString(String key) => _prefs.getString(key);

  static List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Deletes..
  static Future<bool>? remove(String key) async => await _prefs.remove(key);

  static Future<bool> clear() async => await _prefs.clear();

  static void setId(int userId) {
    setInt('user_id', userId);
  }

  static int? getId() {
    return getInt("user_id");
  }

  static void setIsOtpVerified(bool isVerified) {
    setBool('is_otp_verified', isVerified);
  }

  static bool? getIsOtpVerified() {
    return getBool('is_otp_verified');
  }

  static void setIsKycVerified(bool isVerified) {
    setBool('is_kyc_verified', isVerified);
  }

  static bool? getIsKycVerified() {
    return getBool('is_kyc_verified');
  }

  static void setToken(String access_token) {
    setString("access_token", access_token);
  }

  static String? getToken() {
    return getString('access_token');
  }

  static void setMobile(String mobile) {
    setString("mobile", mobile);
  }

  static String? getMobile() {
    return getString('mobile');
  }

  static Future<void> setDeliveryAddress(String address) async {
    await setString('delivery_address', address);
  }

  static String? getDeliveryAddress() {
    return getString('delivery_address');
  }

  static Future<void> setLatitude(double latitude) async {
    await setDouble('latitude', latitude);
  }

  static double? getLatitude() {
    return getDouble('latitude');
  }

  static Future<void> setLongitude(double longitude) async {
    await setDouble('longitude', longitude);
  }

  static double? getLongitude() {
    return getDouble('longitude');
  }

  static void setPermission(String data) {
    setString("permission", data);
  }

  static String? getPermission() {
    return getString('permission');
  }

  static void setFcmToken(String token) {
    setString("fcm_token", token);
  }

  static String? getFcmToken() {
    return getString("fcm_token");
  }

  static Future<void> verifyOtp(String verifyOtp) async {
    await setString("verify_otp", verifyOtp);
  }

  static String? getVerify() {
    return getString("verify_otp");
  }

  static Future<void> setRideId(int rideId) async {
    await setInt('ride_id', rideId);
  }

  static int? getRideId() {
    return getInt('ride_id');
  }

  static Future<void> clearRideId() async {
    await remove('ride_id');
  }
}
