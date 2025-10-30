import 'dart:async';

import 'package:apni_ride_user/pages/home/dashboard.dart';
import 'package:apni_ride_user/pages/start_trip_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/BookingStatus1/booking_status_cubit1.dart';
import '../bloc/BookingStatus1/booking_status_state.dart';
import '../bloc/CancelRide/cancel_ride_cubit.dart';
import '../bloc/CancelRide/cancel_ride_state.dart';
import '../bloc/ReachedLocation/reached_location_cubit.dart';
import '../bloc/ReachedLocation/reached_location_state.dart';
import '../config/constant.dart';
import '../utills/background_service_location.dart';
import '../utills/shared_preference.dart';
import '../widgets/custom_divider.dart';
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
  final String paymentTypes;
  bool? isFromHistory;

  ReachedPickUpLocation({
    super.key,
    required this.rideData,
    required this.paymentTypes,
    this.isFromHistory = false,
  });

  @override
  State<ReachedPickUpLocation> createState() => _ReachedPickUpLocationState();
}

class _ReachedPickUpLocationState extends State<ReachedPickUpLocation> {
  Timer? _bookingStatusTimer;
  final BackgroundService _backgroundService = BackgroundService();
  String type = "";

  @override
  void initState() {
    super.initState();
    print("widgetData ${widget.rideData}");
    _initializeFirebase();
    _startBookingStatusCheck();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.signInAnonymously();
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChatScreen(
              rideId: widget.rideData['ride_id'].toString(),
              userType: 'driver',
            ),
      ),
    );
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

  Future<void> _startBookingStatusCheck() async {
    final bookingId = widget.rideData['booking_id']?.toString() ?? '0';
    final rideId = widget.rideData['ride_id']?.toString() ?? 'Unknown';
    await _backgroundService.startRideTracking(rideId);
    print("bookingId ${bookingId}");
    _bookingStatusTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context.read<BookingStatusCubit1>().fetchBookingStatus(
        context,
        bookingId,
      );
    });
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
              MultiBlocListener(
                listeners: [
                  BlocListener<ReachedLocationCubit, ReachedLocationState>(
                    listener: (context, state) {
                      if (state is ReachedLocationSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.reachedLocation.message),
                          ),
                        );
                        _bookingStatusTimer?.cancel();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => StartTripScreen(
                                  rideData: widget.rideData,
                                  otp: state.reachedLocation.ride.otp,
                                  paymentTypes: widget.paymentTypes,
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
                  BlocListener<CancelRideCubit, CancelRideState>(
                    listener: (context, state) {
                      // _backgroundService.stopRideTracking();
                      // Navigator.of(context).pushAndRemoveUntil(
                      //   MaterialPageRoute(builder: (context) => const Home()),
                      //   (route) => false,
                      // );
                      if (state is CancelRideSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.cancelRide.statusMessage),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } else if (state is CancelRideError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 25.h,
                      ), // Space for the Cancel Trip button
                      /// Ride ID
                      /* Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "ORDER ID: $rideId",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ),*/

                      /// Earning + Distance
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                                      "₹ ${state is ReachedLocationSuccess ? state.reachedLocation.ride.fare : ExpectedEarnings ?? '100'}",
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
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
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
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
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
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          //  border: Border.all(width: 1, color: primaryColor),
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
                                        ),
                                        SizedBox(height: 15.h),
                                        Text(
                                          "Drop Location",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
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
                                            Icons.directions,
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
                                      GestureDetector(
                                        onTap: () {
                                          print("Call to this number");
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
                                      // GestureDetector(
                                      //   onTap: _openChat,
                                      //   child: Container(
                                      //     padding: const EdgeInsets.all(8),
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.grey.shade300,
                                      //       shape: BoxShape.circle,
                                      //     ),
                                      //     child: const Icon(
                                      //       Icons.chat,
                                      //       size: 20,
                                      //       color: primaryColor,
                                      //     ),
                                      //   ),
                                      // ),
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
              // Positioned(
              //   top: 20.h,
              //   right: 10.w,
              //   child: GestureDetector(
              //     onTap: () async {
              //       Navigator.pop(context);
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
              //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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
              child: const Icon(
                Icons.double_arrow_rounded,
                color: primaryColor,
              ),
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
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String rideId;
  final String userType; // 'user' or 'driver'

  const ChatScreen({super.key, required this.rideId, required this.userType});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _firestore
        .collection('chats')
        .doc(widget.rideId)
        .collection('messages')
        .add({
          'text': _messageController.text.trim(),
          'sender': widget.userType,
          'timestamp': FieldValue.serverTimestamp(),
        });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore
                      .collection('chats')
                      .doc(widget.rideId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['sender'] == widget.userType;
                    return ListTile(
                      title: Text(msg['text']),
                      subtitle: Text(
                        isMe
                            ? 'You'
                            : (widget.userType == 'user' ? 'Driver' : 'User'),
                      ),
                      trailing: isMe ? const Icon(Icons.person) : null,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
