import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apni_ride_user/model/get_profile_model.dart';
import 'package:apni_ride_user/model/location_update.dart';
import 'package:apni_ride_user/model/register_model.dart';
import 'package:apni_ride_user/model/ride_accept.dart';
import 'package:apni_ride_user/model/update_status.dart';
import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/login_model.dart';

late GlobalKey<NavigatorState> _navigatorKey;

clearUserData() async {}

class ApiBaseHelper {
  initApiService(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static const _baseUrl = "http://192.168.0.15:8000/api/";

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 300),
      /* receiveDataWhenStatusError: true,
      receiveTimeout: const Duration(seconds: 300),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,*/
      // receiveTimeout: 3000,
    ),
  );

  dynamic _returnResponse(Response response) {
    print("response.statusCode");
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return responseJson;
      case 201:
        var responseJson = response.data;
        return responseJson;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
        throw UnAuthorisedException(response.data.toString());
      case 403:
        throw UnAuthorisedException(response.data.toString());

      case 500:
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }

  Map<String, String> getMainHeaders() {
    String? token = SharedPreferenceHelper.getToken() ?? "";
    print("Print ${token}");
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (token != null && token != "") {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(String url) async {
    String params = "";

    var apiUrl = _baseUrl + url + params;
    var headers = getMainHeaders();
    print("apiurl ${apiUrl}");
    print(headers);

    dynamic responseJson;
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(headers: headers),
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      if (e.toString().contains("401")) {
        clearUserData();
        throw Exception('token_expired');
      } else if (e.toString().contains("403")) {
        /*  _showToast(
          _navigatorKey.currentContext!,
          "your_account_is_disabled_Please_contact_admin".tr(),
        );*/
        clearUserData();
        throw Exception('user_inactive');
      } else {
        throw Exception(e.toString());
      }
    }

    return responseJson;
  }

  void _showToast(BuildContext context, message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<dynamic> post(String url, [dynamic body]) async {
    String params = "";

    var apiUrl = _baseUrl + url + params;
    var headers = getMainHeaders();
    dynamic responseJson;
    print("apiUrl ${apiUrl}");
    print("");
    print("headers ${headers}");
    try {
      final response = await dio.post(
        apiUrl,
        data: body,
        options:
            headers['Authorization'] != null ? Options(headers: headers) : null,
      );
      print("responseresponse ${response}");
      responseJson = _returnResponse(response);
    } catch (e) {
      print("sfsdsdsd");
      print(e.toString());
      if (e.toString().contains("401")) {
        clearUserData();
        throw Exception('token_expired');
      } else if (e.toString().contains("403")) {
        /* _showToast(
          _navigatorKey.currentContext!,
          "your_account_is_disabled_Please_contact_admin".tr(),
        );*/
        clearUserData();
        throw Exception('user_inactive');
      } else {
        throw Exception(e.toString());
      }
    }

    return responseJson;
  }

  Future<dynamic> put(String url, [dynamic body]) async {
    var headers = getMainHeaders();
    dynamic responseJson;
    try {
      final response = await dio.put(
        url,
        data: jsonEncode(body),
        options: Options(headers: headers),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> patch(String url, [dynamic body]) async {
    var apiUrl = "${_baseUrl}" + url;
    print("apiUrl: $apiUrl");
    var headers = getMainHeaders();
    print("Headers: $headers");

    try {
      final response = await dio.patch(
        apiUrl,
        data: body,
        options: Options(headers: headers),
      );

      print("Response body: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw FetchDataException('No Internet connection');
      }
      print("Dio error: ${e.message}");
      if (e.response != null) {
        print("Error response: ${e.response?.data}");
        throw FetchDataException(
          'Error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw FetchDataException('Unexpected error: ${e.message}');
      }
    } catch (e) {
      print("Unexpected error: $e");
      throw FetchDataException('Unexpected error: $e');
    }
  }

  Future<dynamic> delete(String url) async {
    var headers = getMainHeaders();
    dynamic apiResponse;
    try {
      final response = await dio.delete(
        url,
        options: Options(headers: headers),
      );
      apiResponse = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return apiResponse;
  }
}

class ApiService {
  ApiService();

  initApiService(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  final ApiBaseHelper _helper = ApiBaseHelper();

  // Future<AppData> getAppData() async {
  //   print("objectaas");
  //   final body = {};
  //   final response = await _helper.post("app_data", body);
  //   print(response);
  //   return appDataFromJson(response);
  // }
  //
  // Future<LanguageData> getLanguageData() async {
  //   final bosy = {"acess_token": "ssfs"};
  //   final response = await _helper.get("get_list/language");
  //   return languageDataFromJson(response);
  // }
  Future<LoginData> login(data) async {
    print("datsasa$data");
    final response = await _helper.post("driver/login", data);
    print("response");
    return loginDataFromJson(response);
  }

  Future<RegisterData> registerData(data) async {
    print("datsasa$data");
    final response = await _helper.post("driver/register", data);
    print("response ${response}");
    return registerDataFromJson(response);
  }

  Future<UpdateStatus> updateStatus(data) async {
    final id = SharedPreferenceHelper.getId();
    print("idid ${id}");
    print("datsasa$data");
    final response = await _helper.patch("driver/${id}/online-status/", data);
    print("response Switch ${response}");
    return updateStatusFromJson(response);
  }

  Future<UpdateStatus> getUpdateStatus() async {
    final id = SharedPreferenceHelper.getId();
    print("idid ${id}");
    final response = await _helper.get("driver/${id}/online-status/");
    print("response Switch ${response}");
    return updateStatusFromJson(response);
  }

  Future<LocationUpdate> updateLocation(data) async {
    print("datadatadata$data");
    final response = await _helper.post("location/update/", data);
    print("responsefromLocationUpdate ${response}");
    return locationUpdateFromJson(response);
  }

  Future<GetProfile> getProfile() async {
    final response = await _helper.get("profile/");
    print("response ${response}");
    return getProfileFromJson(response);
  }

  Future<UpdateStatus> updateFcm(data) async {
    print("datsasa$data");
    final response = await _helper.patch("fcm/token", data);
    print("getFcmResponse ${response}");
    return updateStatusFromJson(response);
  }

  Future<AcceptRide> acceptRide(data) async {
    print("datsasa$data");
    final response = await _helper.patch("rides/accept/90/", data);
    print("getFcmResponse ${response}");
    return acceptRideFromJson(response);
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
    : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnAuthorisedException extends AppException {
  UnAuthorisedException([message]) : super(message, "UnAuthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
