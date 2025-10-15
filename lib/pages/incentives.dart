import 'package:apni_ride_user/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/Incentives/incentives_cubit.dart';
import '../../model/driver_incentives.dart';
import '../bloc/Incentives/incentives_state.dart';

class Incentives extends StatefulWidget {
  const Incentives({super.key});

  @override
  State<Incentives> createState() => _IncentivesState();
}

class _IncentivesState extends State<Incentives> {
  @override
  void initState() {
    super.initState();
    context.read<IncentivesCubit>().getIncentives();
  }

  Widget percentageCard(String rides, String days, String earn, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$rides rides completed",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "$days left",
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
              "${(value * 100).toInt()}%",
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
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.percent, color: primaryColor),
          ),
          SizedBox(width: 8.w),
          Text(
            "Earn ₹$cashback cashback",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget earnedMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Text(
        "Your earnings added to your wallet",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
      body: BlocBuilder<IncentivesCubit, IncentivesState>(
        builder: (context, state) {
          if (state is IncentivesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IncentivesError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is IncentivesSuccess) {
            final incentives = state.driverIncentives.data;
            return SingleChildScrollView(
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
                    // Dynamically build cards for each incentive
                    ...incentives.map((incentive) {
                      final rides =
                          incentive.minRides == 'N/A'
                              ? '${incentive.ridesCompleted}'
                              : '${incentive.ridesCompleted}/${incentive.minRides.replaceAll('Rides', '')}';
                      final days =
                          '7'; // Replace with dynamic value if available
                      final earn = incentive.driverIncentive.toStringAsFixed(0);
                      final progress = incentive.progressPercent / 100.0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          percentageCard(rides, days, earn, progress),
                          SizedBox(height: 10.h),
                          cashBackCard(earn),
                          if (incentive.earned) earnedMessage(),
                          SizedBox(height: 25.h),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}
