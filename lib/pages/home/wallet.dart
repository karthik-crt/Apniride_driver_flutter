import 'package:apni_ride_user/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constant.dart';
import '../../widgets/custom_form_field.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Wallet & Withdrawal",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.addWallet);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                "Add Wallet",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "₹2000,50",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.sp,
                    ),
                  ),
                  Text(
                    "Available balance",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Bank Account Number",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
            ),
            SizedBox(height: 5.h),
            CustomTextFormField(hintText: "Phone number", marginHorizontal: 0),
            SizedBox(height: 5.h),
            Text(
              "UPI ID",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
            ),
            SizedBox(height: 5.h),
            CustomTextFormField(hintText: "UPI ID", marginHorizontal: 0),
            SizedBox(height: 5.h),
            Text(
              "Withdrawal Amount",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
            ),
            SizedBox(height: 5.h),
            CustomTextFormField(hintText: "UPI ID", marginHorizontal: 0),
            SizedBox(height: 5.h),
            Text(
              "Minimum withdrawal : ₹100",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: 15.h, right: 15.w, left: 15.w),

              width: MediaQuery.sizeOf(context).width,
              height: 45.h,
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
                  //Navigator.pushNamed(context, AppRoutes.home);
                },
                child: Text(
                  "Withdraw now",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
