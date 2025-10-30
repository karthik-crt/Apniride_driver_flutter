// import 'dart:io';
//
// import 'package:apni_ride_user/bloc/UpdateStatus/update_status_cubit.dart';
// import 'package:apni_ride_user/config/constant.dart';
// import 'package:apni_ride_user/pages/rides_history.dart';
// import 'package:apni_ride_user/utills/api_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../bloc/Location/location_cubit.dart';
// import '../../bloc/UpdateStatus/update_status_state.dart';
// import '../../routes/app_routes.dart';
// import '../../utills/background_service_location.dart';
// import '../../utills/shared_preference.dart';
//
// import 'package:apni_ride_user/bloc/GetProfile/get_profile_cubit.dart';
// import 'package:apni_ride_user/bloc/GetProfile/get_profile_state.dart';
// // ... other imports remain the same
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   bool isOnline = false;
//   LatLng? _currentPosition;
//   bool _isMapLoading = true;
//   String? _username;
//   String? _approvalState;
//   final BackgroundService backgroundService = BackgroundService();
//   final ApiService apiService = ApiService();
//
//   @override
//   void initState() {
//     super.initState();
//     updateFcm();
//     _fetchProfile();
//     _fetchInitialStatus();
//     _fetchCurrentLocation();
//   }
//
//   updateFcm() async {
//     print("Update fcm");
//     String? token = await FirebaseMessaging.instance.getToken();
//     if (token != null) {
//       print("FCM Token: $token");
//       SharedPreferenceHelper.setFcmToken(token);
//       final data = {"fcm_token": token};
//       apiService.updateFcm(data);
//     }
//   }
//
//   _fetchProfile() async {
//     print("Enter into fetchProfile");
//     try {
//       await context.read<GetProfileCubit>().getUpdateStatus();
//     } catch (e) {
//       print("Failed to fetch profile: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed to load profile data")));
//     }
//   }
//
//   _fetchInitialStatus() async {
//     print("Enter into fetchInitialStatus");
//     try {
//       final status = await context.read<UpdateStatusCubit>().getUpdateStatus();
//       setState(() {
//         isOnline = status.isOnline;
//         print("isOnlineisOnline $isOnline");
//       });
//       if (status.isOnline && _approvalState == "approved") {
//         await backgroundService.initializeService();
//       }
//     } catch (e) {
//       print("Failed to fetch initial status: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed to load online status")));
//     }
//   }
//
//   Future<void> _fetchCurrentLocation() async {
//     print("Enter into fetch current location");
//     try {
//       double? latitude = SharedPreferenceHelper.getLatitude();
//       double? longitude = SharedPreferenceHelper.getLongitude();
//
//       if (latitude != null && longitude != null) {
//         setState(() {
//           _currentPosition = LatLng(latitude, longitude);
//           _isMapLoading = false;
//         });
//       } else {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         setState(() {
//           _currentPosition = LatLng(position.latitude, position.longitude);
//           _isMapLoading = false;
//         });
//         await SharedPreferenceHelper.setLatitude(position.latitude);
//         await SharedPreferenceHelper.setLongitude(position.longitude);
//       }
//     } catch (e) {
//       print("Error fetching location: $e");
//       setState(() {
//         _isMapLoading = false;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed to get current location")));
//     }
//   }
//
//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Logout',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(fontSize: 20.sp),
//           ),
//           content: Text(
//             'Are you sure you want to logout?',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(fontSize: 16.sp, color: Colors.grey),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Logout',
//                 style: TextStyle(fontSize: 16.sp, color: primaryColor),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<UpdateStatusCubit, UpdateStatusState>(
//           listener: (context, state) {
//             if (state is UpdateStatusSuccess) {
//               setState(() {
//                 isOnline = state.status.isOnline;
//               });
//               if (state.status.isOnline && _approvalState == "approved") {
//                 backgroundService.initializeService();
//               } else {
//                 backgroundService.stopService();
//               }
//             } else if (state is UpdateStatusError) {
//               setState(() {
//                 isOnline = !isOnline;
//               });
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.message)));
//             }
//           },
//         ),
//         BlocListener<GetProfileCubit, GetProfileState>(
//           listener: (context, state) {
//             if (state is GetProfileSuccess) {
//               setState(() {
//                 _username = state.getProfile.data.username;
//                 _approvalState = state.getProfile.data.approvalState;
//               });
//             } else if (state is GetProfileError) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.message)));
//             }
//           },
//         ),
//       ],
//       child: SafeArea(
//         child: Scaffold(
//           drawer: Drawer(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 DrawerHeader(
//                   decoration: BoxDecoration(color: primaryColor),
//                   child: Center(
//                     child: Text(
//                       _username ?? 'USERNAME',
//                       style: TextStyle(color: Colors.white, fontSize: 24.sp),
//                     ),
//                   ),
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.history, size: 20.sp),
//                   title: Text(
//                     'Ratings',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, AppRoutes.rating);
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.person, size: 20.sp),
//                   title: Text(
//                     'Incentives',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, AppRoutes.incentives);
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.list_alt_outlined, size: 20.sp),
//                   title: Text(
//                     'Rides History',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RidesHistories()),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.info, size: 20.sp),
//                   title: Text(
//                     'About',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
//                   ),
//                   onTap: () {
//                     // Handle About navigation
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.description, size: 20.sp),
//                   title: Text(
//                     'Privacy Policy',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, AppRoutes.policy);
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.logout, size: 20.sp),
//                   title: Text(
//                     'Logout',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
//                   ),
//                   onTap: () {
//                     _showLogoutDialog();
//                   },
//                 ),
//               ],
//             ),
//           ),
//           body: RefreshIndicator(
//             onRefresh: () async {
//               await _fetchInitialStatus();
//               await _fetchProfile();
//             },
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Builder(
//                         builder: (BuildContext context) {
//                           return GestureDetector(
//                             onTap: () {
//                               Scaffold.of(context).openDrawer();
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                 color: primaryColor,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Icon(
//                                 Icons.menu,
//                                 size: 20.sp,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(context, AppRoutes.notification);
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             color: primaryColor,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Icon(
//                             Icons.notifications,
//                             size: 20.sp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.h),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 15.w,
//                       vertical: 8.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.circle,
//                               color: isOnline ? Colors.green : Colors.red,
//                             ),
//                             SizedBox(width: 5.w),
//                             Text(isOnline ? "Online" : "Offline"),
//                             Spacer(),
//                             Transform.scale(
//                               scale: 0.8,
//                               child: Switch(
//                                 value: isOnline,
//                                 onChanged:
//                                     _approvalState == "approved"
//                                         ? (value) async {
//                                           setState(() {
//                                             isOnline = value;
//                                           });
//                                           context
//                                               .read<UpdateStatusCubit>()
//                                               .updateStatus(value, context);
//                                         }
//                                         : null, // Disable switch if not approved
//                               ),
//                             ),
//                           ],
//                         ),
//                         if (_approvalState != "approved") ...[
//                           SizedBox(height: 10.h),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 10.w,
//                               vertical: 10.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               "Your Details is verifying, please wait for approval",
//                               style: Theme.of(context).textTheme.bodyMedium
//                                   ?.copyWith(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                         SizedBox(height: 28.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "₹2000.50",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headlineSmall
//                                       ?.copyWith(color: primaryColor),
//                                 ),
//                                 Text(
//                                   "Today's earnings",
//                                   style: Theme.of(
//                                     context,
//                                   ).textTheme.bodySmall?.copyWith(
//                                     color: Colors.grey.shade500,
//                                     fontSize: 11.5.sp,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(Icons.star, size: 18, color: primaryColor),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "4.8",
//                                       style:
//                                           Theme.of(
//                                             context,
//                                           ).textTheme.headlineSmall?.copyWith(),
//                                     ),
//                                     Text(
//                                       "Ratings",
//                                       style: Theme.of(
//                                         context,
//                                       ).textTheme.bodySmall?.copyWith(
//                                         color: Colors.grey.shade500,
//                                         fontSize: 11.5.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(
//                                   Icons.person_outline_sharp,
//                                   size: 18,
//                                   color: primaryColor,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "12",
//                                       style:
//                                           Theme.of(
//                                             context,
//                                           ).textTheme.headlineSmall?.copyWith(),
//                                     ),
//                                     Text(
//                                       "Trip today",
//                                       style: Theme.of(
//                                         context,
//                                       ).textTheme.bodySmall?.copyWith(
//                                         color: Colors.grey.shade500,
//                                         fontSize: 11.5.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 15.h),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Container(
//                     height: 200.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child:
//                         _isMapLoading
//                             ? Center(child: CircularProgressIndicator())
//                             : _currentPosition == null
//                             ? Center(child: Text("Unable to load location"))
//                             : GoogleMap(
//                               initialCameraPosition: CameraPosition(
//                                 target: _currentPosition!,
//                                 zoom: 15.0,
//                               ),
//                               myLocationEnabled: true,
//                               myLocationButtonEnabled: true,
//                               zoomGesturesEnabled: true,
//                               scrollGesturesEnabled: true,
//                               tiltGesturesEnabled: true,
//                               rotateGesturesEnabled: true,
//                               gestureRecognizers: {
//                                 Factory<OneSequenceGestureRecognizer>(
//                                   () => EagerGestureRecognizer(),
//                                 ),
//                               },
//                               markers: {
//                                 Marker(
//                                   markerId: MarkerId('current_location'),
//                                   position: _currentPosition!,
//                                   infoWindow: InfoWindow(
//                                     title: 'Your Location',
//                                   ),
//                                 ),
//                               },
//                             ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         radius: 20.r,
//                         backgroundColor: primaryMaterialColor.shade300,
//                         child: Image.asset(
//                           "assets/images/cashback.png",
//                           width: 22.w,
//                           height: 30.w,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       title: Text(
//                         "Drive More. Earn More",
//                         style: Theme.of(context).textTheme.headlineMedium,
//                       ),
//                       subtitle: Text(
//                         "Earn up to 10% cashback on completed trips",
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.grey.shade600,
//                           fontSize: 11.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   buildTripRequest(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTripRequest() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 45.h,
//               width: 45.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Image.asset("assets/images/profile.png"),
//             ),
//             SizedBox(width: 8.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Sarah Johnson",
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 Text(
//                   "New ride request",
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: Colors.grey.shade600,
//                     fontSize: 11.sp,
//                   ),
//                 ),
//               ],
//             ),
//             Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   "₹100.50",
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     color: primaryColor,
//                     fontSize: 15.sp,
//                   ),
//                 ),
//                 Text(
//                   "3.2 mi",
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: Colors.grey.shade600,
//                     fontSize: 11.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: 8.h),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(Icons.circle, size: 20, color: Colors.green),
//             SizedBox(width: 10.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Pickup",
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
//                 ),
//                 Text(
//                   "123 Main Street, Downtown",
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: 18.h),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(Icons.circle, size: 20, color: Colors.red),
//             SizedBox(width: 10.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Destination",
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
//                 ),
//                 Text(
//                   "456 Oak Main Street, Uptown",
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: 25.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.r),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Text(
//                 "End Trip",
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 // Navigator.pushNamed(context, AppRoutes.newRideRequest);
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 child: Text(
//                   "Start Trip",
//                   style: Theme.of(
//                     context,
//                   ).textTheme.headlineSmall?.copyWith(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'package:apni_ride_user/bloc/GetProfile/get_profile_cubit.dart';
import 'package:apni_ride_user/bloc/GetProfile/get_profile_state.dart';
import 'package:apni_ride_user/bloc/UpdateStatus/update_status_cubit.dart';
import 'package:apni_ride_user/bloc/UpdateStatus/update_status_state.dart';
import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/pages/rides_history.dart';
import 'package:apni_ride_user/pages/wallet_history_screen.dart';
import 'package:apni_ride_user/utills/api_service.dart';
import 'package:apni_ride_user/utills/background_service_location.dart';
import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Bloc/RidesHistory/rides_history_state.dart';
import '../../bloc/Dashbord/dashboard_cubit.dart';
import '../../bloc/Dashbord/dashboard_state.dart';
import '../../bloc/RidesHistory/rides_history_cubit.dart';
import '../../routes/app_routes.dart';
import '../reached_pick_up_location.dart';
import '../splash.dart';
import '../start_trip_screen.dart';
import '../trip_complete_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isOnline = false;
  LatLng? _currentPosition;
  bool _isMapLoading = true;
  String? _username;
  String? _approvalState;
  final BackgroundService backgroundService = BackgroundService();
  final ApiService apiService = ApiService();
  bool _isLocationPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    updateFcm();
    _validateLocationForOnline();
    _fetchProfile();
    _fetchInitialStatus();
    _fetchCurrentLocation();
    _fetchDashboardData();
    context.read<RidesHistoryCubit>().fetchRidesHistory(context);
    // Periodic check
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      bool valid = await _validateLocationForOnline();
      if (!valid && isOnline) {
        setState(() {
          isOnline = false;
        });
        context.read<UpdateStatusCubit>().updateStatus(false, context);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Location service is off. Please enable it to stay online.",
              ),
            ),
          );
        }
      }
    });
  }

  Future<bool> _validateLocationForOnline() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _isLocationPermissionDenied = true;
        });
      }
      return false;
    }

    PermissionStatus status = await Permission.locationAlways.status;
    print("Location permission status: $status");
    if (!status.isGranted) {
      if (mounted) {
        setState(() {
          _isLocationPermissionDenied = true;
        });
      }
      return false;
    }

    if (mounted) {
      setState(() {
        _isLocationPermissionDenied = false;
      });
    }
    return true;
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isMapLoading = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isMapLoading = false;
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
        if (mounted) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            _isMapLoading = false;
            _isLocationPermissionDenied = false;
          });
        }
      } catch (e) {
        print("Error getting location: $e");
        if (mounted) {
          setState(() {
            _isMapLoading = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to get location. Please try again."),
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _isMapLoading = false;
          _isLocationPermissionDenied = true;
        });
      }
      if (status.isPermanentlyDenied) {
        _showPermissionDeniedDialog();
      } else {
        SharedPreferenceHelper.setPermission('denied');
        Navigator.pushNamed(context, AppRoutes.location).then((_) {
          _validateLocationForOnline(); // Fixed: Use the correct method
        });
      }
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
                onPressed: () {
                  Navigator.pop(ctx);
                  SharedPreferenceHelper.setPermission('denied');
                  Navigator.pushNamed(context, AppRoutes.location);
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
                onPressed: () {
                  Navigator.pop(ctx);
                  SharedPreferenceHelper.setPermission('denied');
                  Navigator.pushNamed(context, AppRoutes.location);
                },
                child: const Text("Continue Anyway"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await openAppSettings();
                  _requestLocationPermission();
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
    );
  }

  Widget _buildCurrentRides() {
    return BlocBuilder<RidesHistoryCubit, RidesHistoryState>(
      builder: (context, state) {
        if (state is RidesHistoryLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is RidesHistorySuccess) {
          final rides =
              state.ridesHistory.rides
                  .where(
                    (ride) => [
                      'accepted',
                      'arrived',
                      'ongoing',
                    ].contains(ride.status?.toLowerCase()),
                  )
                  .toList();

          if (rides.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Text(
                "No current rides available",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              String formattedDate;
              try {
                final utcDateTime = DateTime.parse(ride.pickupTime ?? '');
                const int istOffsetHours = 5;
                const int istOffsetMinutes = 30;
                final istDateTime = utcDateTime.add(
                  const Duration(
                    hours: istOffsetHours,
                    minutes: istOffsetMinutes,
                  ),
                );
                formattedDate = DateFormat(
                  'MMM dd, yyyy - hh:mm a',
                ).format(istDateTime);
              } catch (e) {
                formattedDate = 'Invalid date';
                print("Date parsing error for ride ${ride.bookingId}: $e");
              }

              final rideData = {
                'ride_id': ride.id?.toString() ?? '0',
                'pickup_location': ride.pickup ?? 'Unknown',
                'drop_location': ride.drop ?? 'Unknown',
                'driver_to_pickup_km': ride.driverToPickup?.toString() ?? '0',
                'pickup_to_drop_km': ride.distanceKm?.toString() ?? '0',
                'fare': ride.fare?.toString() ?? '0',
                'booking_id': ride.bookingId ?? 'Unknown',
                'user_number': ride.userNumber ?? 'Unknown',
                'excepted_earnings': ride.expectedEarnings?.toString() ?? '0',
              };

              return GestureDetector(
                onTap: () {
                  if (ride.status?.toLowerCase() == 'accepted') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ReachedPickUpLocation(
                              rideData: rideData,
                              paymentTypes: ride.paymentType ?? '',
                              isFromHistory: true,
                            ),
                      ),
                    );
                  } else if (ride.status?.toLowerCase() == 'arrived') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => StartTripScreen(
                              rideData: rideData,
                              otp: ride.otp ?? '',
                              paymentTypes: ride.paymentType ?? '',
                              isFromHistory: true,
                            ),
                      ),
                    );
                  } else if (ride.status?.toLowerCase() == 'ongoing') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TripCompletedScreen(
                              rideData: rideData,
                              paymentTypes: ride.paymentType ?? '',
                              isFromHistory: true,
                            ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Booking ID: ${ride.bookingId ?? 'Unknown'}",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontSize: 15.sp),
                          ),
                          Text(
                            "₹${(ride.fare ?? 0).toStringAsFixed(2)}",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              color: primaryColor,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 20,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pickup",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  ride.pickup ?? 'Unknown',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontSize: 14.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, size: 20, color: Colors.red),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Destination",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  ride.drop ?? 'Unknown',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontSize: 14.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status: ${(ride.status ?? '')}",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is RidesHistoryError) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
                fontSize: 14.sp,
              ),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Text(
            "No current rides available",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  updateFcm() async {
    print("Update fcm");
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("FCM Token: $token");
      SharedPreferenceHelper.setFcmToken(token);
      final data = {"fcm_token": token};
      apiService.updateFcm(data);
    }
  }

  _fetchProfile() async {
    print("Enter into fetchProfile");
    try {
      await context.read<GetProfileCubit>().getUpdateStatus();
    } catch (e) {
      print("Failed to fetch profile: $e");
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Failed to load profile data")));
    }
  }

  Future<void> _fetchInitialStatus() async {
    print("Enter into fetchInitialStatus");
    try {
      final status = await context.read<UpdateStatusCubit>().getUpdateStatus();
      setState(() {
        isOnline = status.isOnline;
        print("isOnlineisOnline $isOnline");
      });
      if (status.isOnline && _approvalState == "approved") {
        bool locationValid = await _validateLocationForOnline();
        if (locationValid && !_isLocationPermissionDenied) {
          await backgroundService.initializeService();
        } else {
          setState(() {
            isOnline = false;
          }); // Force offline
          context.read<UpdateStatusCubit>().updateStatus(false, context);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location required to go online.")),
            );
          }
        }
      }
    } catch (e) {
      print("Failed to fetch initial status: $e");
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Failed to load online status")));
    }
  }

  Future<void> _fetchCurrentLocation() async {
    print("Enter into fetch current location");
    try {
      if (!_isLocationPermissionDenied) {
        double? latitude = SharedPreferenceHelper.getLatitude();
        double? longitude = SharedPreferenceHelper.getLongitude();

        if (latitude != null && longitude != null) {
          setState(() {
            _currentPosition = LatLng(latitude, longitude);
            _isMapLoading = false;
          });
        } else {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            _isMapLoading = false;
          });
          await SharedPreferenceHelper.setLatitude(position.latitude);
          await SharedPreferenceHelper.setLongitude(position.longitude);
        }
      }
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        _isMapLoading = false;
      });
    }
  }

  // Fetch dashboard data
  _fetchDashboardData() async {
    print("Enter into fetchDashboardData");
    try {
      await context.read<DashboardCubit>().getDashboardDetails(context);
    } catch (e) {
      print("Failed to fetch dashboard data: $e");
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Failed to load dashboard data")));
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                backgroundService.stopService();
                context.read<UpdateStatusCubit>().updateStatus(false, context);
                final Map<String, dynamic> data = {
                  "latitude": "0.000",
                  "longitude": "0.000",
                };
                final response = await apiService.updateLocation(data);
                print("response of location ${response}");
                SharedPreferenceHelper.clear();
                String? token = await FirebaseMessaging.instance.getToken();
                if (token != null) {
                  debugPrint('FCMToken: $token');
                  SharedPreferenceHelper.setFcmToken(token);
                }
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Splash()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16.sp, color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateStatusCubit, UpdateStatusState>(
          listener: (context, state) {
            if (state is UpdateStatusSuccess) {
              setState(() {
                isOnline = state.status.isOnline;
              });
              if (state.status.isOnline &&
                  _approvalState == "approved" &&
                  !_isLocationPermissionDenied) {
                backgroundService.initializeService();
              } else {
                backgroundService.stopService();
              }
            } else if (state is UpdateStatusError) {
              setState(() {
                isOnline = !isOnline;
              });
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<GetProfileCubit, GetProfileState>(
          listener: (context, state) {
            if (state is GetProfileSuccess) {
              setState(() {
                _username = state.getProfile.data.username;
                _approvalState = state.getProfile.data.approvalState;
              });
            } else if (state is GetProfileError) {
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        // Add listener for DashboardCubit
        BlocListener<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state is DashboardError) {
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: primaryColor),
                  child: Center(
                    child: Text(
                      _username ?? 'USERNAME',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.history, size: 20.sp),
                  title: Text(
                    'Ratings',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.rating);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person, size: 20.sp),
                  title: Text(
                    'Incentives',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.incentives);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.wallet, size: 20.sp),
                  title: Text(
                    'Wallet History',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalletHistoryScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list_alt_outlined, size: 20.sp),
                  title: Text(
                    'Rides History',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RidesHistories()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info, size: 20.sp),
                  title: Text(
                    'About',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                  ),
                  onTap: () {
                    // Handle About navigation
                  },
                ),
                ListTile(
                  leading: Icon(Icons.description, size: 20.sp),
                  title: Text(
                    'Privacy Policy',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.policy);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, size: 20.sp),
                  title: Text(
                    'Logout',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                  ),
                  onTap: () {
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await _fetchInitialStatus();
              await _fetchProfile();
              await _fetchDashboardData();
              await _validateLocationForOnline(); // Added: Re-validate on refresh
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.menu,
                                size: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.pushNamed(context, AppRoutes.notification);
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(5),
                      //     decoration: BoxDecoration(
                      //       color: primaryColor,
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //     child: Icon(
                      //       Icons.notifications,
                      //       size: 20.sp,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  if (_isLocationPermissionDenied) ...[
                    SizedBox(height: 10.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "We need access to your background location. Please enabled location and set to 'Allow all the time'.",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                            onPressed: _requestLocationPermission,
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: isOnline ? Colors.green : Colors.red,
                              ),
                              SizedBox(width: 5.w),
                              Text(isOnline ? "Online" : "Offline"),
                              Spacer(),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: isOnline,
                                  onChanged:
                                      (_approvalState == "approved" &&
                                              !_isLocationPermissionDenied)
                                          ? (value) async {
                                            bool locationValid =
                                                await _validateLocationForOnline(); // Fixed typo
                                            if (!locationValid) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Enable location services and set to 'Allow all the time' to go online.",
                                                  ),
                                                ),
                                              );
                                              return; // Block toggle
                                            }

                                            setState(() {
                                              isOnline = value;
                                            });
                                            context
                                                .read<UpdateStatusCubit>()
                                                .updateStatus(value, context);
                                          }
                                          : null, // Disabled if not approved or location denied
                                ),
                              ),
                            ],
                          ),
                          if (_approvalState != "approved") ...[
                            SizedBox(height: 10.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Your Details is verifying, please wait for approval",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                          SizedBox(height: 28.h),
                          // Display dashboard data dynamically
                          BlocBuilder<DashboardCubit, DashboardState>(
                            builder: (context, state) {
                              if (state is DashboardLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is DashboardSuccess) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹${state.dashboard.data.todayEarnings.toStringAsFixed(2)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(color: primaryColor),
                                        ),
                                        Text(
                                          "Today's earnings",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey.shade500,
                                            fontSize: 11.5.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 18,
                                          color: primaryColor,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.dashboard.data.averageRating
                                                  .toStringAsFixed(1),
                                              style:
                                                  Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall
                                                      ?.copyWith(),
                                            ),
                                            Text(
                                              "Ratings",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                color: Colors.grey.shade500,
                                                fontSize: 11.5.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.person_outline_sharp,
                                          size: 18,
                                          color: primaryColor,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.dashboard.data.tripsToday
                                                  .toString(),
                                              style:
                                                  Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall
                                                      ?.copyWith(),
                                            ),
                                            Text(
                                              "Trip today",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                color: Colors.grey.shade500,
                                                fontSize: 11.5.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else if (state is DashboardError) {
                                return Text(
                                  "Error: ${state.message}",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.red),
                                );
                              }
                              return SizedBox(); // Fallback for initial state
                            },
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 10.h),
                  Container(
                    height: 200.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child:
                        _isMapLoading
                            ? Center(child: CircularProgressIndicator())
                            : _currentPosition == null
                            ? Center(child: Text("Unable to load location"))
                            : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _currentPosition!,
                                zoom: 15.0,
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomGesturesEnabled: true,
                              scrollGesturesEnabled: true,
                              tiltGesturesEnabled: true,
                              rotateGesturesEnabled: true,
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },
                              markers: {
                                Marker(
                                  markerId: MarkerId('current_location'),
                                  position: _currentPosition!,
                                  infoWindow: InfoWindow(
                                    title: 'Your Location',
                                  ),
                                ),
                              },
                            ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: primaryMaterialColor.shade300,
                        child: Image.asset(
                          "assets/images/cashback.png",
                          width: 22.w,
                          height: 30.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: Text(
                        "Drive More. Earn More",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      subtitle: Text(
                        "Earn up to 10% cashback on completed trips",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildCurrentRides(),
                  //buildTripRequest(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTripRequest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset("assets/images/profile.png"),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sarah Johnson",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  "New ride request",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹100.50",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    // Fixed: style:
                    color: primaryColor,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  "3.2 mi",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.circle, size: 20, color: Colors.green),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pickup",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                ),
                Text(
                  "123 Main Street, Downtown",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.circle, size: 20, color: Colors.red),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Destination",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                ),
                Text(
                  "456 Oak Main Street, Uptown",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 25.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                "End Trip",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, AppRoutes.newRideRequest);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "Start Trip",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
