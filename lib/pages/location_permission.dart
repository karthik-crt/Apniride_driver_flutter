// import 'package:apni_ride_user/config/constant.dart';
// import 'package:apni_ride_user/utills/shared_preference.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart' as geocoding;
// import 'package:permission_handler/permission_handler.dart';
// import '../routes/app_routes.dart';
//
// class LocationPopup extends StatefulWidget {
//   const LocationPopup({super.key});
//
//   @override
//   State<LocationPopup> createState() => _LocationPopupState();
// }
//
// class _LocationPopupState extends State<LocationPopup> {
//   bool isLoading = false;
//
//   Future<void> _requestLocationPermission() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         isLoading = false;
//       });
//       _showLocationServiceDialog();
//       return;
//     }
//     PermissionStatus status = await Permission.locationAlways.status;
//     if (!status.isGranted) {
//       status = await Permission.locationAlways.request();
//     }
//
//     if (status.isGranted) {
//       SharedPreferenceHelper.setPermission('agree');
//       print("Location permission granted: Allow all the time");
//
//       try {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         await SharedPreferenceHelper.setLatitude(position.latitude);
//         await SharedPreferenceHelper.setLongitude(position.longitude);
//         try {
//           List<geocoding.Placemark> placemarks = await geocoding
//               .placemarkFromCoordinates(position.latitude, position.longitude);
//           if (placemarks.isNotEmpty) {
//             geocoding.Placemark placemark = placemarks.first;
//             String address =
//                 [
//                   placemark.street,
//                   placemark.locality,
//                   placemark.administrativeArea,
//                   placemark.country,
//                 ].where((s) => s != null && s.isNotEmpty).join(', ').trim();
//             await SharedPreferenceHelper.setDeliveryAddress(
//               address.isEmpty ? 'Unknown Address' : address,
//             );
//           } else {
//             await SharedPreferenceHelper.setDeliveryAddress('Unknown Address');
//           }
//         } catch (e) {
//           print("Error getting address: $e");
//           await SharedPreferenceHelper.setDeliveryAddress('Unknown Address');
//         }
//
//         // Navigate to welcome screen
//         setState(() {
//           isLoading = false;
//         });
//         Navigator.pushNamed(context, AppRoutes.welcome);
//       } catch (e) {
//         print("Error getting location: $e");
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Failed to get location. Please try again."),
//           ),
//         );
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       if (status.isPermanentlyDenied) {
//         _showPermissionDeniedDialog();
//       } else {
//         SharedPreferenceHelper.setPermission('denied');
//         Navigator.pushNamed(context, AppRoutes.welcome);
//       }
//     }
//   }
//
//   void _showLocationServiceDialog() {
//     showDialog(
//       context: context,
//       builder:
//           (ctx) => AlertDialog(
//             title: const Text("Enable Location Services"),
//             content: const Text(
//               "Location services are disabled. Please enable them to allow the app to track your location.",
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(ctx);
//                   SharedPreferenceHelper.setPermission('denied');
//                   Navigator.pushNamed(context, AppRoutes.welcome);
//                 },
//                 child: const Text("Continue Anyway"),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(ctx);
//                   await Geolocator.openLocationSettings();
//                   _requestLocationPermission();
//                 },
//                 child: const Text("Open Settings"),
//               ),
//             ],
//           ),
//     );
//   }
//
//   void _showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder:
//           (ctx) => AlertDialog(
//             title: const Text("Location Permission Required"),
//             content: const Text(
//               "This app requires 'Allow all the time' location access to function properly. Please enable it in the app settings.",
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(ctx);
//                   SharedPreferenceHelper.setPermission('denied');
//                   Navigator.pushNamed(context, AppRoutes.welcome);
//                 },
//                 child: const Text("Continue Anyway"),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(ctx);
//                   await openAppSettings();
//                   // Re-check after returning from settings
//                   _requestLocationPermission();
//                 },
//                 child: const Text("Open Settings"),
//               ),
//             ],
//           ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Center(
//                 child: Container(
//                   margin: const EdgeInsets.all(20),
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         color: primaryColor,
//                         size: 60,
//                       ),
//                       SizedBox(height: 16.h),
//                       Text(
//                         "Background Location Permission",
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         "Our app collects your device’s background location to find nearby users. "
//                         "By allowing background location access, we can provide real-time tracking.",
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                       SizedBox(height: 20.h),
//                       Text(
//                         "Please allow location permission set to “Allow all the time” to continue.\n"
//                         "Go to: Permissions → Location → Allow all the time",
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                       SizedBox(height: 20.h),
//                       Container(
//                         margin: EdgeInsets.only(top: 15.h),
//                         width: MediaQuery.sizeOf(context).width,
//                         height: 40.h,
//                         child: ElevatedButton(
//                           style: ButtonStyle(
//                             shape: MaterialStateProperty.all<
//                               RoundedRectangleBorder
//                             >(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                           onPressed: _requestLocationPermission,
//                           child: Text(
//                             "Continue",
//                             style: Theme.of(
//                               context,
//                             ).textTheme.bodySmall?.copyWith(
//                               color: Colors.white,
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//     );
//   }
// }
import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:permission_handler/permission_handler.dart';
import '../routes/app_routes.dart';

class LocationPopup extends StatefulWidget {
  const LocationPopup({super.key});

  @override
  State<LocationPopup> createState() => _LocationPopupState();
}

class _LocationPopupState extends State<LocationPopup> {
  bool isLoading = false;

  Future<void> _requestLocationPermission() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isLoading = false;
      });
      _showLocationServiceDialog();
      return;
    }

    PermissionStatus status = await Permission.locationAlways.status;
    print("Permission status: $status"); // Debug log
    if (!status.isGranted) {
      status = await Permission.locationAlways.request();
    }

    if (status.isGranted) {
      SharedPreferenceHelper.setPermission('agree');
      print("Location permission granted: Allow all the time");

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
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

        setState(() {
          isLoading = false;
        });
        String? token = SharedPreferenceHelper.getToken();
        if (token != null && token.isNotEmpty) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.welcome);
        }
      } catch (e) {
        print("Error getting location: $e");
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to get location. Please try again."),
          ),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showPermissionDeniedDialog();
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Enable Location Services"),
            content: const Text(
              "Location services are disabled. Please enable them to allow the app to track your location.",
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  SharedPreferenceHelper.setPermission('denied');
                  Navigator.pushReplacementNamed(context, AppRoutes.location);
                },
                child: const Text("Continue Anyway"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await Geolocator.openLocationSettings();
                  _requestLocationPermission();
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Location Permission Required"),
            content: const Text(
              "This app requires 'Allow all the time' location access to function properly. Please enable it in the app settings.",
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  SharedPreferenceHelper.setPermission('denied');
                  Navigator.pushReplacementNamed(context, AppRoutes.location);
                },
                child: const Text("Continue Anyway"),
              ),
              TextButton(
                onPressed: () async {
                  //Navigator.pop(ctx);
                  await openAppSettings();
                  _requestLocationPermission();
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 60,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Background Location Permission",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Our app collects your device’s background location to find nearby users. "
                        "By allowing background location access, we can provide real-time tracking.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Please allow location permission set to “Allow all the time” to continue.\n"
                        "Go to: Permissions → Location → Allow all the time",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        margin: EdgeInsets.only(top: 15.h),
                        width: MediaQuery.sizeOf(context).width,
                        height: 40.h,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                              RoundedRectangleBorder
                            >(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: _requestLocationPermission,
                          child: Text(
                            "Continue",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
