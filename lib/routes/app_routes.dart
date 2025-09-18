import 'package:apni_ride_user/pages/add_wallet_screen.dart';
import 'package:apni_ride_user/pages/home/home.dart';
import 'package:apni_ride_user/pages/location_permission.dart';
import 'package:apni_ride_user/pages/notification.dart';
import 'package:apni_ride_user/pages/privacy_policy.dart';
import 'package:apni_ride_user/pages/ratings.dart';
import 'package:apni_ride_user/pages/register.dart';
import 'package:apni_ride_user/pages/ride_request_screen.dart';
import 'package:flutter/material.dart';

import '../pages/home/wallet.dart';
import '../pages/incentives.dart';
import '../pages/login.dart';
import '../pages/welcome.dart';
import '../pages/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String wallet = '/wallet';
  static const String rating = '/ratings';
  static const String policy = '/policy';
  static const String incentives = '/incentives';
  static const String notification = '/notification';
  static const String location = '/location';
  static const String addWallet = '/addWallet';
  static const String newRideRequest = '/newRideRequest';

  static const String initialRoute = splash;

  static Route<dynamic> onGenerateRoutes(RouteSettings route) {
    switch (route.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => Splash());
      case welcome:
        return MaterialPageRoute(builder: (context) => Welcome());
      case login:
        return MaterialPageRoute(builder: (context) => Login());
      case register:
        return MaterialPageRoute(builder: (context) => Register());
      case home:
        return MaterialPageRoute(builder: (context) => Home());
      case wallet:
        return MaterialPageRoute(builder: (context) => Wallet());
      case rating:
        return MaterialPageRoute(builder: (context) => RatingsScreen());
      case policy:
        return MaterialPageRoute(builder: (context) => PrivacyPolicy());
      case incentives:
        return MaterialPageRoute(builder: (context) => Incentives());
      case notification:
        return MaterialPageRoute(builder: (context) => NotificationScreen());
      case location:
        return MaterialPageRoute(builder: (context) => LocationPopup());
      case addWallet:
        return MaterialPageRoute(builder: (context) => AddWalletScreen());
      // case newRideRequest:
      //   return MaterialPageRoute(builder: (context) => NewRideRequest());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(child: Text('No route defined for ${route.name}')),
              ),
        );
    }
  }
}
