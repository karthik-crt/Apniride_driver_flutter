import 'package:apni_ride_user/config/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Incentives extends StatefulWidget {
  const Incentives({super.key});

  @override
  State<Incentives> createState() => _IncentivesState();
}

class _IncentivesState extends State<Incentives> {
  @override
  Widget percentageCard(String rides, String days, String earn, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${rides} rides completed",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "${days} left",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.grey.shade300,
                color: primaryColor,
              ),
            ),
            Text(
              "${value * 100}",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          "Earn ₹$earn",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget cashBackCard(String cashback) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.percent, color: primaryColor),
          ),
          SizedBox(width: 8.w),
          Text(
            "Earn ₹${cashback} cashback",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Incentives",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Progress",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 25.h),
              percentageCard('10/20', "7", "500", 0.80),
              SizedBox(height: 10.h),
              cashBackCard("500"),
              SizedBox(height: 25.h),
              percentageCard('15/20', "3", "100", 0.50),
              SizedBox(height: 10.h),
              cashBackCard("300"),
              SizedBox(height: 25.h),
              percentageCard('5/20', "15", "100", 0.30),
              SizedBox(height: 5.h),
              cashBackCard("500"),
            ],
          ),
        ),
      ),
    );
  }
}
