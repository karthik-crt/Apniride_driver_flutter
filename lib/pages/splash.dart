import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../routes/app_routes.dart';
import '../utills/shared_preference.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialDialogNotification();
    });
  }

  Future<void> _saveLocationData(Position position) async {
    await SharedPreferenceHelper.setLatitude(position.latitude);
    await SharedPreferenceHelper.setLongitude(position.longitude);
    try {
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        geocoding.Placemark placemark = placemarks.first;
        String address =
            [
              placemark.street,
              placemark.locality,
              placemark.administrativeArea,
              placemark.country,
            ].where((s) => s != null && s.isNotEmpty).join(', ').trim();
        await SharedPreferenceHelper.setDeliveryAddress(
          address.isEmpty ? 'Unknown Address' : address,
        );
      } else {
        await SharedPreferenceHelper.setDeliveryAddress('Unknown Address');
      }
    } catch (e) {
      print("Error getting address: $e");
      await SharedPreferenceHelper.setDeliveryAddress('Unknown Address');
    }
  }

  Future<Position> fetchLocationByDeviceGPS() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.requestPermission();
        if (!await Geolocator.isLocationServiceEnabled()) {
          Navigator.pushReplacementNamed(context, AppRoutes.location);
          throw 'Location services are disabled.';
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      print("Location permission status: $permission"); // Debug log
      if (permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        await _saveLocationData(position);
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
        return position;
      } else {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition();
          await _saveLocationData(position);
          Navigator.pushReplacementNamed(context, AppRoutes.welcome);
          return position;
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.location);
          throw 'Location permission not set to Always.';
        }
      }
    } catch (e) {
      print("Error in fetchLocationByDeviceGPS: $e");
      Navigator.pushReplacementNamed(context, AppRoutes.location);
      rethrow;
    }
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    print("Notification permission status: $status"); // Debug log
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }

    if (status.isGranted) {
      SharedPreferenceHelper.setString('notification_permission', 'agree');
      print("Notification permission granted");
      await initialDialogLocation();
    } else {
      SharedPreferenceHelper.setString('notification_permission', 'denied');
      if (status.isPermanentlyDenied) {
        _showNotificationPermissionDeniedDialog();
      } else {
        await initialDialogLocation();
      }
    }
  }

  void _showNotificationPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Notification Permission Required"),
            content: const Text(
              "This app requires notification access to send you updates. Please enable it in the app settings.",
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  SharedPreferenceHelper.setString(
                    'notification_permission',
                    'denied',
                  );
                  await initialDialogLocation(); // Proceed to location permission
                },
                child: const Text("Continue Anyway"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await openAppSettings();
                  await _requestNotificationPermission(); // Re-check after settings
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
    );
  }

  void initialDialogNotification() {
    final token = SharedPreferenceHelper.getToken();
    print("tokentokentoken $token");
    if (token != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text("Notification Permission Required"),
              content: const Text(
                "Please allow notifications to receive updates from the app.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    SharedPreferenceHelper.setString(
                      'notification_permission',
                      'denied',
                    );
                    Navigator.pop(ctx);
                    initialDialogLocation(); // Proceed to location permission
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _requestNotificationPermission();
                  },
                  child: const Text("Agree"),
                ),
              ],
            ),
      );
    }
  }

  Future<void> initialDialogLocation() async {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Background Location Required"),
            content: const Text(
              "Please enable location services to allow the app to track your location.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  SharedPreferenceHelper.setPermission('denied');
                  Navigator.pop(ctx);
                  Navigator.pushReplacementNamed(context, AppRoutes.location);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await fetchLocationByDeviceGPS();
                },
                child: const Text("Agree"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset("assets/images/logo.png")));
  }
}
