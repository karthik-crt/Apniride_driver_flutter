import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/pages/trip_complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../bloc/StartTrip/start_trip_cubit.dart';
import '../bloc/StartTrip/start_trip_state.dart';
import '../utills/map_utils.dart';
import '../utills/shared_preference.dart';
import 'package:flutter/services.dart';

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

  const StartTripScreen({super.key, required this.rideData, required this.otp});

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  final TextEditingController _otpController = TextEditingController();

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

                  if (enteredOtp.isEmpty || enteredOtp.length != 4) {
                    ScaffoldMessenger.of(modalContext).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a 4-digit OTP"),
                      ),
                    );
                    return;
                  }

                  if (enteredOtp == storedOtp && enteredOtp == apiOtp) {
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

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
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
                              (context) =>
                                  TripCompletedScreen(rideData: rideData),
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
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h), // Space for the Cancel Trip button
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
                    Card(
                      shape: RoundedRectangleBorder(
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
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                      onSwipe: () {
                        _showOtpModal(context, widget.otp);
                      },
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
            // Cancel Trip Button Above Ride ID Card
            Positioned(
              top: 20.h,
              right: 10.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Navigate back to previous screen
                  // Optionally, trigger a BLoC event for canceling the trip
                  // context.read<CancelTripCubit>().cancelTrip(rideId);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    "Cancel Trip",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            if (context.watch<StartTripCubit>().state is StartTripLoading)
              const Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
          ],
        ),
      ),
    );
  }
}
