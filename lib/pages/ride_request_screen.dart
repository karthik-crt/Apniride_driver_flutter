// import 'package:apni_ride_user/config/constant.dart';
// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_swipe_button/flutter_swipe_button.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../bloc/AcceptRide/accept_ride_cubit.dart';
// import '../bloc/AcceptRide/accept_ride_state.dart';
//
// class NewRideRequest extends StatefulWidget {
//   const NewRideRequest({super.key});
//
//   @override
//   State<NewRideRequest> createState() => _NewRideRequestState();
// }
//
// class _NewRideRequestState extends State<NewRideRequest> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<AcceptRideCubit, AcceptRideState>(
//         listener: (context, state) {
//           if (state is AcceptRideSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.acceptRide.statusMessage)),
//             );
//             Navigator.pop(context);
//           } else if (state is AcceptRideError) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (context, state) {
//           return Stack(
//             children: [
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           right: 8.0,
//                           top: 5,
//                           bottom: 5,
//                         ),
//                         child: Align(
//                           alignment: Alignment.centerRight,
//                           child: ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               backgroundColor: const Color(0xfffd0502),
//                             ),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(
//                               Icons.close_rounded,
//                               size: 20,
//                               color: Colors.white,
//                             ),
//                             label: Text(
//                               "Deny",
//                               style: Theme.of(context).textTheme.bodyMedium
//                                   ?.copyWith(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const Center(child: Text("New Ride!")),
//                       SizedBox(height: 20.h),
//                       SizedBox(
//                         height: 180.w,
//                         width: 180.h,
//                         child: Stack(
//                           fit: StackFit.expand,
//                           children: [
//                             CircularCountDownTimer(
//                               duration: 60,
//                               initialDuration: 0,
//                               controller: CountDownController(),
//                               width: MediaQuery.of(context).size.width / 2,
//                               height: MediaQuery.of(context).size.height / 2,
//                               ringColor: Colors.white,
//                               fillColor: const Color(0xffFF3D3D),
//                               backgroundColor: Colors.grey[200],
//                               strokeWidth: 10.0,
//                               strokeCap: StrokeCap.round,
//                               textFormat: CountdownTextFormat.S,
//                               isReverse: false,
//                               isReverseAnimation: false,
//                               isTimerTextShown: true,
//                               autoStart: true,
//                               onStart: () {
//                                 print('Countdown Started');
//                               },
//                               onComplete: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             Positioned(
//                               top: (205 - 96) / 2,
//                               left: 0,
//                               right: 0,
//                               child: Image.asset(
//                                 'assets/images/car.png',
//                                 width: 158,
//                                 height: 96,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const Center(child: Text("RIDE ID: 12345")),
//                       const SizedBox(height: 10),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1, color: primaryColor),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: double.infinity,
//                               alignment: Alignment.center,
//                               child: const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text("Expected Earning:"),
//                                     Text("₹ 500"),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       border: Border(
//                                         top: BorderSide(
//                                           width: 1,
//                                           color: primaryColor,
//                                         ),
//                                         right: BorderSide(
//                                           width: 1,
//                                           color: primaryColor,
//                                         ),
//                                       ),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: const Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 10,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Pickup:"),
//                                           Text("5 Kms"),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       border: Border(
//                                         top: BorderSide(
//                                           width: 1,
//                                           color: primaryColor,
//                                         ),
//                                       ),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: const Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 10,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Dropping:"),
//                                           Text("10 Kms"),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1, color: primaryColor),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         width: double.infinity,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Image.asset(
//                                         "assets/images/Pickup.png",
//                                         height: 20,
//                                       ),
//                                       SizedBox(
//                                         height: 40,
//                                         width: 1,
//                                         child: CustomPaint(
//                                           size: Size(1, double.infinity),
//                                           painter: DashedLineVerticalPainter(),
//                                         ),
//                                       ),
//                                       Icon(
//                                         Icons.location_on,
//                                         color: primaryColor,
//                                         size: 28,
//                                       ),
//                                       SizedBox(
//                                         height: 0,
//                                         width: 1,
//                                         child: CustomPaint(
//                                           size: Size(1, double.infinity),
//                                           painter: DashedLineVerticalPainter(),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(width: 5),
//                                   SizedBox(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.7,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text("Pickup Location:"),
//                                         const SizedBox(height: 1),
//                                         SizedBox(
//                                           width:
//                                               MediaQuery.of(
//                                                 context,
//                                               ).size.width *
//                                               0.8,
//                                           height: 40,
//                                           child: const Text(
//                                             "Sample Pickup Address",
//                                             maxLines: 3,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 1),
//                                         const Text("Drop Location:"),
//                                         const SizedBox(height: 1),
//                                         SizedBox(
//                                           width:
//                                               MediaQuery.of(
//                                                 context,
//                                               ).size.width *
//                                               0.8,
//                                           height: 50,
//                                           child: const Text(
//                                             "Sample Drop Address",
//                                             maxLines: 3,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(bottom: 8.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Pickup Date & Time",
//                                           style:
//                                               Theme.of(
//                                                 context,
//                                               ).textTheme.bodyMedium,
//                                         ),
//                                         SizedBox(height: 3),
//                                         Text(
//                                           "2025-09-05, 10:00 AM",
//                                           style:
//                                               Theme.of(
//                                                 context,
//                                               ).textTheme.bodyMedium,
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Drop Date & Time",
//                                           style:
//                                               Theme.of(
//                                                 context,
//                                               ).textTheme.bodyMedium,
//                                         ),
//                                         SizedBox(height: 3),
//                                         Text(
//                                           "2025-09-05, 12:00 PM",
//                                           style:
//                                               Theme.of(
//                                                 context,
//                                               ).textTheme.bodyMedium,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 65),
//                     ],
//                   ),
//                 ),
//               ),
//               if (state is AcceptRideLoading)
//                 Center(child: CircularProgressIndicator(color: primaryColor)),
//             ],
//           );
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: SwipeButton(
//           trackPadding: const EdgeInsets.all(5),
//           borderRadius: BorderRadius.circular(30),
//           activeTrackColor: primaryColor,
//           height: 60,
//           thumb: Container(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//             child: Icon(Icons.double_arrow_rounded, color: primaryColor),
//           ),
//           activeThumbColor: Colors.grey,
//           child: const Text(
//             "ACCEPT THE TRIP",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           onSwipe: () {
//             final data = {"pickup": "Manimaran backery", "drop": "Teppakulam"};
//             context.read<AcceptRideCubit>().acceptRide("103", data, context);
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class DashedLineVerticalPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     double dashHeight = 3, dashSpace = 2, startY = 0;
//     final paint =
//         Paint()
//           ..color = Color(0xff7D7D7C)
//           ..strokeWidth = size.width;
//     while (startY < size.height) {
//       canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
//       startY += dashHeight + dashSpace;
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/pages/reached_pick_up_location.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import '../bloc/AcceptRide/accept_ride_cubit.dart';
import '../bloc/AcceptRide/accept_ride_state.dart';
import '../bloc/BookingStatus/booking_status_cubit.dart';
import '../bloc/BookingStatus/booking_status_state.dart';
import '../utills/shared_preference.dart';

class NewRideRequest extends StatefulWidget {
  final Map<String, dynamic> rideData;

  const NewRideRequest({super.key, required this.rideData});

  @override
  State<NewRideRequest> createState() => _NewRideRequestState();
}

class _NewRideRequestState extends State<NewRideRequest> {
  @override
  Widget build(BuildContext context) {
    final rideData = widget.rideData;
    print("rideData $rideData");
    final bookingId = rideData['booking_id']?.toString() ?? '0';
    final rideId = rideData['ride_id']?.toString() ?? 'Unknown';
    final pickupLocation = rideData['pickup_location']?.toString() ?? 'Unknown';
    final dropLocation = rideData['drop_location']?.toString() ?? 'Unknown';
    final driverToPickupKm =
        rideData['driver_to_pickup_km']?.toString() ?? '0.0';
    final pickupToDropKm = rideData['pickup_to_drop_km']?.toString() ?? '0.0';

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AcceptRideCubit, AcceptRideState>(
            listener: (context, state) async {
              if (state is AcceptRideSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.acceptRide.statusMessage)),
                );
                // Call booking status API
                await context.read<BookingStatusCubit>().fetchBookingStatus(
                  context,
                  bookingId,
                );
              } else if (state is AcceptRideError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<BookingStatusCubit, BookingStatusState>(
            listener: (context, state) async {
              if (state is BookingStatusSuccess) {
                final otp = state.bookingStatus.data.otp;
                try {
                  await SharedPreferenceHelper.verifyOtp(otp);
                  print('OTP stored: ${SharedPreferenceHelper.getVerify()}');
                  // Navigate to ReachedPickUpLocation after storing OTP
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ReachedPickUpLocation(rideData: widget.rideData),
                    ),
                  );
                } catch (e) {
                  // Handle any errors while storing OTP
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to store OTP: $e')),
                  );
                }
              } else if (state is BookingStatusError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: BlocBuilder<AcceptRideCubit, AcceptRideState>(
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: const Color(0xfffd0502),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Deny",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const Center(child: Text("New Ride!")),
                        SizedBox(height: 20.h),
                        SizedBox(
                          height: 180.w,
                          width: 180.h,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularCountDownTimer(
                                duration: 60,
                                initialDuration: 0,
                                controller: CountDownController(),
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 2,
                                ringColor: Colors.white,
                                fillColor: const Color(0xffFF3D3D),
                                backgroundColor: Colors.grey[200],
                                strokeWidth: 10.0,
                                strokeCap: StrokeCap.round,
                                textFormat: CountdownTextFormat.S,
                                isReverse: false,
                                isReverseAnimation: false,
                                isTimerTextShown: true,
                                autoStart: true,
                                onStart: () {
                                  print('Countdown Started');
                                },
                                onComplete: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Positioned(
                                top: (205 - 96) / 2,
                                left: 0,
                                right: 0,
                                child: Image.asset(
                                  'assets/images/car.png',
                                  width: 158,
                                  height: 96,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(child: Text("RIDE ID: $rideId")),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Expected Earning:"),
                                      Text("₹ 500"),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            width: 1,
                                            color: primaryColor,
                                          ),
                                          right: BorderSide(
                                            width: 1,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("Pickup:"),
                                            Text("$driverToPickupKm Kms"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            width: 1,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("Dropping:"),
                                            Text("$pickupToDropKm Kms"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: primaryColor),
                            borderRadius: BorderRadius.circular(8),
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
                                          height: 40,
                                          width: 1,
                                          child: CustomPaint(
                                            size: Size(1, double.infinity),
                                            painter:
                                                DashedLineVerticalPainter(),
                                          ),
                                        ),
                                        Icon(
                                          Icons.location_on,
                                          color: primaryColor,
                                          size: 28,
                                        ),
                                        SizedBox(
                                          height: 0,
                                          width: 1,
                                          child: CustomPaint(
                                            size: Size(1, double.infinity),
                                            painter:
                                                DashedLineVerticalPainter(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Pickup Location:"),
                                          const SizedBox(height: 1),
                                          SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.8,
                                            height: 40,
                                            child: Text(
                                              pickupLocation,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          const Text("Drop Location:"),
                                          const SizedBox(height: 1),
                                          SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.8,
                                            height: 50,
                                            child: Text(
                                              dropLocation,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pickup Date & Time",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            "2025-09-05, 10:00 AM",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Drop Date & Time",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            "2025-09-05, 12:00 PM",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 65),
                      ],
                    ),
                  ),
                ),
                if (state is AcceptRideLoading ||
                    context.watch<BookingStatusCubit>().state
                        is BookingStatusLoading)
                  Center(child: CircularProgressIndicator(color: primaryColor)),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SwipeButton(
          trackPadding: const EdgeInsets.all(5),
          borderRadius: BorderRadius.circular(30),
          activeTrackColor: primaryColor,
          height: 45.h,
          thumb: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Icon(Icons.double_arrow_rounded, color: primaryColor),
          ),
          activeThumbColor: Colors.grey,
          child: Text(
            "ACCEPT THE TRIP",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          onSwipe: () {
            context.read<AcceptRideCubit>().acceptRide(rideId, {
              "pickup": pickupLocation,
              "drop": dropLocation,
            }, context);
          },
        ),
      ),
    );
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 2, startY = 0;
    final paint =
        Paint()
          ..color = const Color(0xff7D7D7C)
          ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
