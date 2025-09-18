import 'dart:io';
import 'package:apni_ride_user/bloc/AcceptRide/accept_ride_cubit.dart';
import 'package:apni_ride_user/bloc/BookingStatus/booking_status_cubit.dart';
import 'package:apni_ride_user/bloc/GetProfile/get_profile_cubit.dart';
import 'package:apni_ride_user/bloc/ReachedLocation/reached_location_cubit.dart';
import 'package:apni_ride_user/bloc/RidesHistory/rides_history_cubit.dart';
import 'package:apni_ride_user/bloc/StartTrip/start_trip_cubit.dart';
import 'package:apni_ride_user/bloc/TripComplete/trip_complete_cubit.dart';
import 'package:apni_ride_user/bloc/UpdateStatus/update_status_cubit.dart';
import 'package:apni_ride_user/config/app_theme.dart';
import 'package:apni_ride_user/pages/ride_request_screen.dart';
import 'package:apni_ride_user/routes/app_routes.dart';
import 'package:apni_ride_user/utills/api_service.dart';
import 'package:apni_ride_user/utills/notification_service.dart';
import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/Location/location_cubit.dart';
import 'bloc/Login/login_cubit.dart';
import 'bloc/Register/register_cubit.dart';
import 'config/constant.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("BG message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferenceHelper.init();
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    print("FCM Token: $token");
    SharedPreferenceHelper.setFcmToken(token);
  }
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("Refreshed FCM Token: $newToken");
    SharedPreferenceHelper.setFcmToken(newToken);
  });

  await NotificationService.init(navigatorKey);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Foreground message: ${message.data}");
    NotificationService.showNotification(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    print("MessageMessage ${message}");
    if (message != null) {
      final data = message.data;
      print("Initial message data: $data");
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => NewRideRequest(rideData: data)),
      );
    }
  });

  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print("Notification clicked: ${message.data}");
  // });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message != null) {
      final data = message.data;
      print("Initial message data: $data");
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => NewRideRequest(rideData: data)),
      );
    }
  });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size designSize = const Size(360, 690);
    if (Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS) {
      designSize = const Size(360, 690);
    } else if (Theme.of(context).platform == TargetPlatform.macOS) {
      designSize = const Size(1440, 900);
    } else {
      designSize = const Size(1920, 1080);
    }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:
            !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return RepositoryProvider(
      create: (context) => ApiService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => RegisterCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => UpdateStatusCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create:
                (context) => LocationUpdateCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => AcceptRideCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => BookingStatusCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create:
                (context) => ReachedLocationCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => StartTripCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => CompleteTripCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => RidesHistoryCubit(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => GetProfileCubit(context.read<ApiService>()),
          ),
        ],
        child: ScreenUtilInit(
          designSize: designSize,
          splitScreenMode: true,
          builder: (_, child) {
            TextTheme lightTextTheme = TextTheme(
              bodyLarge: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              bodyMedium: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              bodySmall: GoogleFonts.poppins(
                fontSize: kIsWeb ? 15.sp : 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              displayLarge: GoogleFonts.poppins(
                fontSize: kIsWeb ? 40.sp : 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              displayMedium: GoogleFonts.poppins(
                fontSize: kIsWeb ? 36.sp : 28.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              displaySmall: GoogleFonts.poppins(
                fontSize: kIsWeb ? 34.sp : 26.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              headlineMedium: GoogleFonts.poppins(
                fontSize: kIsWeb ? 24.sp : 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              headlineSmall: GoogleFonts.poppins(
                fontSize: kIsWeb ? 20.sp : 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              titleLarge: GoogleFonts.poppins(
                fontSize: kIsWeb ? 28.sp : 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            );

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: appTitle,
              theme: ThemeData(
                colorScheme: ColorScheme.light(primary: primaryColor),
                primarySwatch: primaryMaterialColor,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                ),
                useMaterial3: true,
                dividerTheme: const DividerThemeData(
                  color: Colors.grey,
                  thickness: 0.4,
                ),
                brightness: Brightness.light,
                primaryColor: primaryColor,
                textTheme: lightTextTheme,
              ),
              initialRoute: AppRoutes.initialRoute,
              onGenerateRoute: AppRoutes.onGenerateRoutes,
              navigatorKey: navigatorKey,
            );
          },
        ),
      ),
    );
  }
}
