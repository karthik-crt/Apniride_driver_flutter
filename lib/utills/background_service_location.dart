import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:dio/dio.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'api_service.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final ApiService apiService = ApiService();
  await SharedPreferenceHelper.init();
  WebSocketChannel? channel;
  String? token = await SharedPreferenceHelper.getToken();
  if (token == null) {
    log('No token found, cannot connect to WebSocket');
    return;
  }
  String wsUrl = 'ws://192.168.0.15:8000/ws/driver/location/?token=$token';
  bool isConnected = false;
  Future<void> connectWebSocket() async {
    try {
      channel = IOWebSocketChannel.connect(wsUrl);
      isConnected = true;
      log('WebSocket connected successfully to $wsUrl');
      await channel!.ready;
      channel!.stream.listen(
        (message) {
          log('Received WebSocket message from server: $message');
        },
        onError: (error) {
          log('WebSocket error: $error');
          isConnected = false;
          connectWebSocket();
        },
        onDone: () {
          log('WebSocket connection closed');
          isConnected = false;
          connectWebSocket();
        },
      );
    } catch (e) {
      log('WebSocket connection error: $e');
      isConnected = false;
      await Future.delayed(const Duration(seconds: 5));
      await connectWebSocket();
    }
  }

  void sendLocationUpdate(double latitude, double longitude) {
    print("latitude & longtitude ${latitude},${longitude}");
    if (isConnected && channel != null) {
      final data = {'latitude': latitude, 'longitude': longitude};
      channel!.sink.add(jsonEncode(data));
      log('Sent WebSocket data: $data');
    } else {
      log('WebSocket not connected, unable to send data');
    }
  }

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    channel?.sink.close();
    service.stopSelf();
    log('Service stopped and WebSocket closed');
  });
  await connectWebSocket();
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log("Location services are disabled.");
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log("Location permission denied.");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        log("Location permission permanently denied.");
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      await SharedPreferenceHelper.setLatitude(position.latitude);
      await SharedPreferenceHelper.setLongitude(position.longitude);

      sendLocationUpdate(position.latitude, position.longitude);

      final Map<String, dynamic> data = {
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
      };
      log("Sending HTTP location data: $data");
      final response = await apiService.updateLocation(data);
      log("HTTP location update response: ${response.toJson()}");

      service.invoke("locationUpdate", {
        "latitude": position.latitude,
        "longitude": position.longitude,
        //"status": response.statusCode ?? "unknown",
      });
    } catch (e, stackTrace) {
      log("Error updating location: $e\n$stackTrace");
      if (!isConnected) {
        await connectWebSocket();
      }
    }
  });
}

class BackgroundService {
  final FlutterBackgroundService flutterBackgroundService =
      FlutterBackgroundService();

  FlutterBackgroundService get instance => flutterBackgroundService;

  Future<void> initializeService() async {
    await flutterBackgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        // notificationChannelId: 'location_tracking_channel',
        // foregroundServiceNotificationId: 888,
        // initialNotificationTitle: 'Location Tracking',
        // initialNotificationContent: 'Tracking your location in the background',
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    await flutterBackgroundService.startService();
  }

  @pragma('vm:entry-point')
  bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    log("iOS background service is running");
    return true;
  }

  void setServiceAsForeground() {
    flutterBackgroundService.invoke("setAsForeground");
  }

  void setServiceAsBackground() {
    flutterBackgroundService.invoke("setAsBackground");
  }

  void stopService() {
    flutterBackgroundService.invoke("stopService");
  }
}
