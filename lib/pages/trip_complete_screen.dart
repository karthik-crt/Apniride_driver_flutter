import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/pages/reached_pick_up_location.dart';
import 'package:apni_ride_user/routes/app_routes.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

import '../../bloc/TripComplete/trip_complete_cubit.dart';
import '../../bloc/TripComplete/trip_complete_state.dart';
import '../utills/background_service_location.dart';
import '../utills/map_utils.dart';
import '../utills/shared_preference.dart';

class TripCompletedScreen extends StatefulWidget {
  final Map<String, dynamic> rideData;

  const TripCompletedScreen({super.key, required this.rideData});

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  late ConfettiController _confettiController;
  bool _isCODCollected = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () async {
          if (mounted) {
            Navigator.pushNamed(context, AppRoutes.home);
          }
        });
        return Stack(
          alignment: Alignment.center,
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                "Trip Completed!",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                "Your trip has been successfully completed!",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
              ],
            ),
          ],
        );
      },
    );
  }

  void _showCODDialog(BuildContext context, String rideId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            "Cash on Delivery",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Cash on Delivery collected from user?",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isCODCollected = true;
                });
                context.read<CompleteTripCubit>().completeTrip(
                  rideId,
                  "completed",
                );
              },
              child: const Text("Confirm"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final BackgroundService _backgroundService = BackgroundService();
    final rideData = widget.rideData;
    final rideId = rideData['ride_id']?.toString() ?? 'Unknown';
    final pickupLocation = rideData['pickup_location']?.toString() ?? 'Unknown';
    final dropLocation = rideData['drop_location']?.toString() ?? 'Unknown';
    final driverToPickupKm =
        rideData['driver_to_pickup_km']?.toString() ?? '0.0';
    final pickupToDropKm = rideData['pickup_to_drop_km']?.toString() ?? '0.0';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: BlocListener<CompleteTripCubit, CompleteTripState>(
          listener: (context, state) {
            if (state is CompleteTripSuccess) {
              _backgroundService.stopRideTracking();
              _showSuccessDialog(context);
            } else if (state is CompleteTripError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "Trip in Progress",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 15.sp),
                  ),
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Text(
                        "RIDE ID: $rideId",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Expected Earning: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "₹ ${rideData['fare']?.toString() ?? '500'}",
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("Pickup"),
                                Text("$driverToPickupKm Kms"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Dropping"),
                                Text("$pickupToDropKm Kms"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: primaryColor),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/images/Pickup.png",
                                  height: 20.h,
                                ),
                                SizedBox(
                                  height: 40.h,
                                  width: 1,
                                  child: CustomPaint(
                                    size: const Size(1, double.infinity),
                                    painter: DashedLineVerticalPainter(),
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 28,
                                ),
                              ],
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Pickup Location"),
                                  SizedBox(height: 1.h),
                                  Text(
                                    pickupLocation,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 15.h),
                                  const Text("Drop Location"),
                                  SizedBox(height: 1.h),
                                  Text(
                                    dropLocation,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chat,
                                    size: 20,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                GestureDetector(
                                  onTap: () {
                                    print("pick up location ${pickupLocation}");
                                    print("drop location ${dropLocation}");
                                    launchGoogleMaps(
                                      context,
                                      pickupLocation,
                                      dropLocation,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade700,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.send,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SwipeButton(
                  trackPadding: const EdgeInsets.all(5),
                  borderRadius: BorderRadius.circular(30.r),
                  activeTrackColor: primaryColor,
                  height: 45.h,
                  thumb: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child: const Icon(
                      Icons.double_arrow_rounded,
                      color: primaryColor,
                    ),
                  ),
                  activeThumbColor: Colors.grey.shade300,
                  child: Text(
                    "Complete Trip",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  onSwipe: () {
                    _showCODDialog(context, rideId);
                  },
                ),
                SizedBox(height: 12.h),
                if (context.watch<CompleteTripCubit>().state
                    is CompleteTripLoading)
                  const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
