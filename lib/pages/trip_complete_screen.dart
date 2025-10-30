import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/pages/home/dashboard.dart';
import 'package:apni_ride_user/pages/reached_pick_up_location.dart';
import 'package:apni_ride_user/routes/app_routes.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
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
import '../widgets/custom_divider.dart';

class TripCompletedScreen extends StatefulWidget {
  final Map<String, dynamic> rideData;
  final String paymentTypes;
  final bool? isFromHistory;

  const TripCompletedScreen({
    super.key,
    required this.rideData,
    required this.paymentTypes,
    this.isFromHistory = false,
  });

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  late ConfettiController _confettiController;
  bool _isCODCollected = false;
  final BackgroundService _backgroundService = BackgroundService();
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    trackRide();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> trackRide() async {
    final rideId = widget.rideData['ride_id']?.toString() ?? 'Unknown';
    await _backgroundService.startRideTracking(rideId);
  }

  void _showSuccessDialog(BuildContext context) {
    setState(() {
      _isDialogShowing = true;
    });

    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () async {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
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
    ).then((_) {
      // Reset the flag when the dialog is dismissed
      if (mounted) {
        setState(() {
          _isDialogShowing = false;
        });
      }
    });
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
    final rideData = widget.rideData;
    final rideId = rideData['ride_id']?.toString() ?? 'Unknown';
    final pickupLocation = rideData['pickup_location']?.toString() ?? 'Unknown';
    final dropLocation = rideData['drop_location']?.toString() ?? 'Unknown';
    final driverToPickupKm =
        rideData['driver_to_pickup_km']?.toString() ?? '0.0';
    final pickupToDropKm = rideData['pickup_to_drop_km']?.toString() ?? '0.0';
    final ExpectedEarnings = rideData['excepted_earnings']?.toString() ?? '0.0';
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromHistory != true) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
            (route) => false,
          );
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              if (widget.isFromHistory != true) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                  (route) => false,
                );
              } else {
                Navigator.pop(context);
              }
            },

            child: Icon(CupertinoIcons.back, color: Colors.black),
          ),
          title: Padding(
            padding: const EdgeInsets.all(0),
            child: Text(
              "#ORDER ID: $rideId",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
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
                  /* Card(
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
                  ),*/
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                              "₹ ${ExpectedEarnings}",
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        DoubleWavyDivider(
                          color: Colors.grey.shade100,
                          height: 3,
                          waveHeight: 5,
                          waveWidth: 10,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Pickup",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey.shade500),
                                ),
                                Text("$driverToPickupKm Kms"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Dropping",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey.shade500),
                                ),
                                Text("$pickupToDropKm Kms"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      //   border: Border.all(width: 1, color: primaryColor),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    "assets/images/Pickup.png",
                                    height: 20,
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
                              const SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pickup Location",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      pickupLocation,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontSize: 13.5),
                                    ),
                                    SizedBox(height: 15.h),
                                    Text(
                                      "Drop Location",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      dropLocation,
                                      maxLines: 3,

                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontSize: 13.5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 40.h),
                                  GestureDetector(
                                    onTap: () {
                                      print(
                                        "pick up location ${pickupLocation}",
                                      );
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
                                        Icons.directions,
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
                      if (widget.paymentTypes == "cod") {
                        _showCODDialog(context, rideId);
                      } else {
                        context.read<CompleteTripCubit>().completeTrip(
                          rideId,
                          "completed",
                        );
                      }
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
      ),
    );
  }
}
