import 'dart:async';

import 'package:apni_ride_user/pages/start_trip_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/BookingStatus1/booking_status_cubit1.dart';
import '../bloc/BookingStatus1/booking_status_state.dart';
import '../bloc/ReachedLocation/reached_location_cubit.dart';
import '../bloc/ReachedLocation/reached_location_state.dart';
import '../config/constant.dart';
import '../utills/background_service_location.dart';
import '../utills/shared_preference.dart';
import 'home/home.dart';
import '../utills/map_utils.dart';

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    const dashHeight = 5;
    const dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ReachedPickUpLocation extends StatefulWidget {
  final Map<String, dynamic> rideData;

  const ReachedPickUpLocation({super.key, required this.rideData});

  @override
  State<ReachedPickUpLocation> createState() => _ReachedPickUpLocationState();
}

class _ReachedPickUpLocationState extends State<ReachedPickUpLocation> {
  Timer? _bookingStatusTimer;
  final BackgroundService _backgroundService = BackgroundService();

  @override
  void initState() {
    super.initState();
    print("widgetData ${widget.rideData}");
    _startBookingStatusCheck();
  }

  void _startBookingStatusCheck() {
    final bookingId = widget.rideData['booking_id']?.toString() ?? '0';
    print("bookingId ${bookingId}");
    _bookingStatusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context.read<BookingStatusCubit1>().fetchBookingStatus(
        context,
        bookingId,
      );
    });
  }

  @override
  void dispose() {
    _bookingStatusTimer?.cancel();
    super.dispose();
  }

  void _showCancellationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Trip Cancelled',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Your trip has been cancelled by the customer. You will be redirected to the home screen.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                _backgroundService.stopRideTracking();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            MultiBlocListener(
              listeners: [
                BlocListener<ReachedLocationCubit, ReachedLocationState>(
                  listener: (context, state) {
                    if (state is ReachedLocationSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.reachedLocation.message)),
                      );
                      _bookingStatusTimer?.cancel();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => StartTripScreen(
                                rideData: widget.rideData,
                                otp: state.reachedLocation.ride.otp,
                              ),
                        ),
                      );
                    } else if (state is ReachedLocationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          action: SnackBarAction(
                            label: 'Retry',
                            onPressed: () {
                              context
                                  .read<ReachedLocationCubit>()
                                  .fetchReachedLocation(rideId);
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
                BlocListener<BookingStatusCubit1, BookingStatusState1>(
                  listener: (context, state) {
                    if (state is BookingStatusSuccess1) {
                      print(
                        "Print BookingStatus ${state.bookingStatus.data.status}",
                      );
                      if (state.bookingStatus.data.status == 'cancelled') {
                        _bookingStatusTimer?.cancel();
                        _showCancellationDialog();
                      }
                    } else if (state is BookingStatusError1) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h), // Space for the Cancel Trip button
                    /// Ride ID
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "RIDE ID: $rideId",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    /// Earning + Distance
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: BlocBuilder<
                          ReachedLocationCubit,
                          ReachedLocationState
                        >(
                          builder: (context, state) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Expected Earning: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "₹ ${state is ReachedLocationSuccess ? state.reachedLocation.ride.fare : 500}",
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: primaryColor),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    GestureDetector(
                                      onTap: () {
                                        print(
                                          "Navigating to pickup location: $pickupLocation",
                                        );
                                        launchGoogleMaps(
                                          context,
                                          pickupLocation,
                                          dropLocation,
                                          useCurrentLocation: true,
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
                                    // Container(
                                    //   padding: const EdgeInsets.all(8),
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.grey.shade300,
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: const Icon(
                                    //     Icons.chat,
                                    //     size: 20,
                                    //     color: primaryColor,
                                    //   ),
                                    // ),
                                    SizedBox(height: 40.h),
                                    Container(
                                      padding: const EdgeInsets.all(8),
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
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20.h,
              right: 10.w,
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    "Cancel Trip",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            if (context.watch<ReachedLocationCubit>().state
                is ReachedLocationLoading)
              const Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: SwipeButton(
          trackPadding: const EdgeInsets.all(5),
          borderRadius: BorderRadius.circular(30),
          activeTrackColor: primaryColor,
          height: 45.h,
          thumb: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: const Icon(Icons.double_arrow_rounded, color: primaryColor),
          ),
          activeThumbColor: Colors.grey.shade400,
          child: Text(
            "Reached Pickup Location",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          onSwipe: () {
            context.read<ReachedLocationCubit>().fetchReachedLocation(rideId);
          },
        ),
      ),
    );
  }
}
