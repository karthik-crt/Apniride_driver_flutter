import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

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
          debugPrint(
            "🚕 Notification clicked with payload: ${details.payload}",
          );
          navigatorKey.currentState?.pushNamed(
            '/tripRequest',
            arguments: details.payload,
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

    await _plugin.show(
      0,
      message.notification?.title ?? "Taxi App",
      message.notification?.body ?? "New ride request",
      notificationDetails,
      payload: message.data['ride_id'],
    );
  }
}
