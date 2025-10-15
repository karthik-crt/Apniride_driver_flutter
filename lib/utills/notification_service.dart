// import 'dart:convert';
//
// import 'package:apni_ride_user/routes/app_routes.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
//
// import '../pages/ride_request_screen.dart';
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _plugin =
//       FlutterLocalNotificationsPlugin();
//
//   static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings();
//     const initSettings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );
//
//     await _plugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         if (details.payload != null) {
//           final data = jsonDecode(details.payload!);
//           print("data data data $data");
//           print("Details data ${details.data}, Details ${details.payload}");
//           debugPrint(" Notification clicked with data: $data");
//           navigatorKey.currentState?.push(
//             MaterialPageRoute(
//               builder: (context) => NewRideRequest(rideData: data),
//             ),
//           );
//         }
//       },
//     );
//   }
//
//   static Future<void> showNotification(RemoteMessage message) async {
//     print("Show notifications");
//     print("Show motifications");
//     print("show notifications");
//     const androidDetails = AndroidNotificationDetails(
//       'ride_channel',
//       'Ride Notifications',
//       channelDescription: 'Channel for ride request notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       sound: RawResourceAndroidNotificationSound('buzzer'),
//       playSound: true,
//     );
//
//     const notificationDetails = NotificationDetails(android: androidDetails);
//     final payload = jsonEncode(message.data);
//     await _plugin.show(
//       0,
//       message.notification?.title ?? "Taxi App",
//       message.notification?.body ?? "New ride request",
//       notificationDetails,
//       payload: payload,
//     );
//   }
// }
// lib/services/notification_service.dart

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import '../pages/ride_request_screen.dart';

const String _rideChannelId = 'ride_channel';
const String _rideChannelName = 'Ride Notifications';
const String _rideChannelDescription = 'Channel for ride request notifications';

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
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _rideChannelId,
      _rideChannelName,
      description: _rideChannelDescription,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('buzzer'),
    );

    final androidImpl =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImpl?.createNotificationChannel(channel);

    //await androidImpl?.requestPermission();
    // 4) Initialize plugin with onDidReceiveNotificationResponse callback
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print("Its Navigating from here");
        if (details.payload != null) {
          try {
            final data = jsonDecode(details.payload!);
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => NewRideRequest(rideData: data),
              ),
            );
          } catch (e) {
            debugPrint(
              'Failed to parse payload: ${details.payload}, error: $e',
            );
          }
        }
      },
    );
  }

  static Future<void> showNotification(RemoteMessage message) async {
    debugPrint('Showing local notification for message: ${message.data}');

    final androidDetails = AndroidNotificationDetails(
      _rideChannelId,
      _rideChannelName,
      channelDescription: _rideChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('buzzer'),
      ticker: 'New ride request',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    final payload = jsonEncode(message.data);
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    try {
      await _plugin.show(
        id,
        message.notification?.title ?? 'Taxi App',
        message.notification?.body ?? 'New ride request',
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
