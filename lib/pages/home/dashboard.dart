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
import 'dart:io';
import 'package:apni_ride_user/bloc/GetProfile/get_profile_cubit.dart';
import 'package:apni_ride_user/bloc/GetProfile/get_profile_state.dart';
import 'package:apni_ride_user/bloc/UpdateStatus/update_status_cubit.dart';
import 'package:apni_ride_user/bloc/UpdateStatus/update_status_state.dart';
import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/pages/rides_history.dart';
import 'package:apni_ride_user/utills/api_service.dart';
import 'package:apni_ride_user/utills/background_service_location.dart';
import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/Dashbord/dashboard_cubit.dart';
import '../../bloc/Dashbord/dashboard_state.dart';
import '../../routes/app_routes.dart';

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

  @override
  void initState() {
    super.initState();
    updateFcm();
    _fetchProfile();
    _fetchInitialStatus();
    _fetchCurrentLocation();
    _fetchDashboardData();
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

  _fetchInitialStatus() async {
    print("Enter into fetchInitialStatus");
    try {
      final status = await context.read<UpdateStatusCubit>().getUpdateStatus();
      setState(() {
        isOnline = status.isOnline;
        print("isOnlineisOnline $isOnline");
      });
      if (status.isOnline && _approvalState == "approved") {
        await backgroundService.initializeService();
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
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        _isMapLoading = false;
      });
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text("Failed to get current location")));
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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
              if (state.status.isOnline && _approvalState == "approved") {
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
              await _fetchDashboardData(); // Refresh dashboard data
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.notification);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.notifications,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
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
                                    _approvalState == "approved"
                                        ? (value) async {
                                          setState(() {
                                            isOnline = value;
                                          });
                                          context
                                              .read<UpdateStatusCubit>()
                                              .updateStatus(value, context);
                                        }
                                        : null,
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
                              return Center(child: CircularProgressIndicator());
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(height: 10.h),
                  Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
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
