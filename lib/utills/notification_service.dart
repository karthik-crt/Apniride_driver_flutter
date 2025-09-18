import 'dart:convert';

import 'package:apni_ride_user/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import '../pages/ride_request_screen.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final data = jsonDecode(details.payload!);
          debugPrint(" Notification clicked with data: $data");

          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => NewRideRequest(rideData: data),
            ),
          );
        }
      },
    );
  }

  static Future<void> showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'ride_channel',
      'Ride Notifications',
      channelDescription: 'Channel for ride request notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    final payload = jsonEncode(message.data);
    await _plugin.show(
      0,
      message.notification?.title ?? "Taxi App",
      message.notification?.body ?? "New ride request",
      notificationDetails,
      payload: payload,
    );
  }
}
