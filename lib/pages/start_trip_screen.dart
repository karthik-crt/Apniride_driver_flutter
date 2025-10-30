import 'dart:async';

import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/pages/home/dashboard.dart';
import 'package:apni_ride_user/pages/trip_complete_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/BookingStatus1/booking_status_cubit1.dart';
import '../bloc/BookingStatus1/booking_status_state.dart';
import '../bloc/CancelRide/cancel_ride_cubit.dart';
import '../bloc/StartTrip/start_trip_cubit.dart';
import '../bloc/StartTrip/start_trip_state.dart';
import '../utills/background_service_location.dart';
import '../utills/map_utils.dart';
import '../utills/shared_preference.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_divider.dart';
import 'home/home.dart';

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

class StartTripScreen extends StatefulWidget {
  final Map<String, dynamic> rideData;
  final String otp;
  final String paymentTypes;
  final bool? isFromHistory;

  const StartTripScreen({
    super.key,
    required this.rideData,
    required this.otp,
    required this.paymentTypes,
    this.isFromHistory = false,
  });

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  final TextEditingController _otpController = TextEditingController();
  final BackgroundService _backgroundService = BackgroundService();
  Timer? _bookingStatusTimer;

  void _showOtpModal(BuildContext parentContext, String apiOtp) {
    TextEditingController modalOtpController = TextEditingController();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
            left: 16.w,
            right: 16.w,
            top: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter OTP to Start Trip",
                style: Theme.of(modalContext).textTheme.titleMedium,
              ),
              SizedBox(height: 16.h),
              PinCodeTextField(
                appContext: modalContext,
                controller: modalOtpController,
                length: 4,
                keyboardType: TextInputType.number,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  borderRadius: BorderRadius.zero,
                  fieldHeight: 50.h,
                  fieldWidth: 50.w,
                  activeColor: Theme.of(modalContext).primaryColor,
                  inactiveColor: primaryColor,
                  selectedColor: Theme.of(modalContext).primaryColor,
                  borderWidth: 2,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                enableActiveFill: false,
                onChanged: (value) {
                  // Optional: Handle OTP changes if needed
                },
              ),
              SizedBox(height: 16.h),
              SwipeButton(
                trackPadding: const EdgeInsets.all(5),
                borderRadius: BorderRadius.circular(30),
                activeTrackColor: Theme.of(modalContext).primaryColor,
                height: 45.h,
                thumb: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: Icon(
                    Icons.double_arrow_rounded,
                    color: Theme.of(modalContext).primaryColor,
                  ),
                ),
                activeThumbColor: Colors.grey.shade300,
                child: const Text(
                  "Confirm OTP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onSwipe: () async {
                  final enteredOtp = modalOtpController.text;
                  final storedOtp = await SharedPreferenceHelper.getVerify();
                  print("entered otp ${enteredOtp}");
                  print("stored otp ${storedOtp}");

                  if (enteredOtp.isEmpty || enteredOtp.length != 4) {
                    ScaffoldMessenger.of(modalContext).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a 4-digit OTP"),
                      ),
                    );
                    return;
                  }

                  if (enteredOtp == apiOtp) {
                    context.read<StartTripCubit>().startTrip(
                      widget.rideData['ride_id'].toString(),
                      enteredOtp,
                    );
                    Navigator.pop(modalContext);
                  } else {
                    print("Invalid OTP");
                    Navigator.pop(modalContext);
                    ScaffoldMessenger.of(modalContext).showSnackBar(
                      const SnackBar(content: Text("Invalid OTP")),
                    );
                  }
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    ).whenComplete(() {
      modalOtpController.dispose(); // Dispose modal controller
    });
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    } catch (e) {
      print('Error launching phone call: $e');
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _bookingStatusTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    trackRide();
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
            'Your trip has been cancelled.wait for another booking',
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

  Future<void> trackRide() async {
    _bookingStatusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context.read<BookingStatusCubit1>().fetchBookingStatus(
        context,
        widget.rideData["booking_id"].toString(),
      );
    });
    final rideId = widget.rideData['ride_id']?.toString() ?? 'Unknown';
    await _backgroundService.startRideTracking(rideId);
  }

  Future<void> _cancelRide(int rideId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Ride'),
          content: const Text('Are you sure you want to cancel this ride?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed:
                  () => context.read<CancelRideCubit>().cancelRides(
                    context,
                    rideId,
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
    final ExpectedEarnings = rideData['excepted_earnings']?.toString() ?? '0.0';
    final userNumber = rideData['user_number']?.toString() ?? '0.0';
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              if (widget.isFromHistory != true) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false,
                );
              } else {
                Navigator.pop(context);
              }
              /*  Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (route) => false,
              );*/
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
          actions: [
            GestureDetector(
              onTap: () {
                _cancelRide(int.parse(rideId));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Cancel Ride",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),

        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Stack(
            children: [
              BlocListener<StartTripCubit, StartTripState>(
                listener: (context, state) {
                  if (state is StartTripSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.startTrip.message)),
                    );
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TripCompletedScreen(
                                  rideData: rideData,
                                  paymentTypes: widget.paymentTypes,
                                ),
                          ),
                        );
                      }
                    });
                  } else if (state is StartTripError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        action: SnackBarAction(
                          label: 'Retry',
                          onPressed: () {
                            _showOtpModal(context, widget.otp);
                          },
                        ),
                      ),
                    );
                  }
                },
                child: BlocConsumer<BookingStatusCubit1, BookingStatusState1>(
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
                  builder: (context, stateStatus) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ), // Space for the Cancel Trip button
                          /* Card(
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
                          ),*/
                          //SizedBox(height: 12.h),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Pickup",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.copyWith(
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          Text("$driverToPickupKm Kms"),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Dropping",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.copyWith(
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              size: const Size(
                                                1,
                                                double.infinity,
                                              ),
                                              painter:
                                                  DashedLineVerticalPainter(),
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
                                          GestureDetector(
                                            onTap: () {
                                              print(
                                                "Phone Number ${userNumber}",
                                              );
                                              makePhoneCall(userNumber);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.call,
                                                size: 20,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 40.h),
                                          GestureDetector(
                                            onTap: () {
                                              print(
                                                "pick up location ${pickupLocation}",
                                              );
                                              print(
                                                "drop location ${dropLocation}",
                                              );
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
                            borderRadius: BorderRadius.circular(30),
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
                              "Start Trip",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            onSwipe: () {
                              _showOtpModal(context, widget.otp);
                            },
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Cancel Trip Button Above Ride ID Card
              // Positioned(
              //   top: 20.h,
              //   right: 10.w,
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.pop(context); // Navigate back to previous screen
              //       // Optionally, trigger a BLoC event for canceling the trip
              //       // context.read<CancelTripCubit>().cancelTrip(rideId);
              //     },
              //     child: Container(
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 5.w,
              //         vertical: 5.h,
              //       ),
              //       decoration: BoxDecoration(
              //         color: Colors.redAccent,
              //         borderRadius: BorderRadius.circular(5.r),
              //       ),
              //       child: Text(
              //         "Cancel Trip",
              //         style: Theme.of(
              //           context,
              //         ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
              if (context.watch<StartTripCubit>().state is StartTripLoading)
                const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
