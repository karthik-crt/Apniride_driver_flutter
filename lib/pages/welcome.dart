import 'package:apni_ride_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

            Image.asset("assets/images/logo.png", height: 150.h, width: 100.w),
            Image.asset("assets/images/Welcome.png"),
            SizedBox(height: 25.h),
            Text(
              "Your trusted ride partner",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Container(
              margin: EdgeInsets.only(top: 8.h),

              child: Text(
                "Seamless bookings at your fingertips your journey, your way",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.h),

              width: MediaQuery.sizeOf(context).width,
              height: 40.h,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // rounded corners
                      // border color
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: Text(
                  "Login now",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.pushNamed(context, AppRoutes.register);
            //   },
            //   child: Container(
            //     margin: EdgeInsets.only(top: 15.h),
            //     width: MediaQuery.sizeOf(context).width,
            //     height: 38.h,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.grey.shade300),
            //       borderRadius: BorderRadius.circular(8.r),
            //     ),
            //     child: Center(
            //       child: Text(
            //         "Register Free",
            //         style: Theme.of(
            //           context,
            //         ).textTheme.bodySmall?.copyWith(fontSize: 14.sp),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
