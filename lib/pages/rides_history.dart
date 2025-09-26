import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/pages/reached_pick_up_location.dart';
import 'package:apni_ride_user/pages/start_trip_screen.dart';
import 'package:apni_ride_user/pages/trip_complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Bloc/RidesHistory/rides_history_state.dart';
import '../bloc/RidesHistory/rides_history_cubit.dart';

class RidesHistories extends StatefulWidget {
  const RidesHistories({Key? key}) : super(key: key);

  @override
  State<RidesHistories> createState() => _RidesHistoriesState();
}

class _RidesHistoriesState extends State<RidesHistories> {
  @override
  void initState() {
    super.initState();
    context.read<RidesHistoryCubit>().fetchRidesHistory(context);
  }

  Future<void> _onRefresh() async {
    await context.read<RidesHistoryCubit>().fetchRidesHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Back",
                      style: textTheme?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<RidesHistoryCubit, RidesHistoryState>(
                  builder: (context, state) {
                    if (state is RidesHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RidesHistorySuccess) {
                      final rides = state.ridesHistory.rides;
                      if (rides.isEmpty) {
                        return const Center(
                          child: Text("No ride history available"),
                        );
                      }
                      return ListView.builder(
                        itemCount: rides.length,
                        itemBuilder: (context, index) {
                          final ride = rides[index];

                          String formattedDate;
                          try {
                            final utcDateTime = DateTime.parse(ride.pickupTime);
                            final int istOffsetHours = 5;
                            final int istOffsetMinutes = 30;
                            final istDateTime = utcDateTime.add(
                              Duration(
                                hours: istOffsetHours,
                                minutes: istOffsetMinutes,
                              ),
                            );
                            print(
                              "Original UTC pickupTime: ${ride.pickupTime}",
                            );
                            print("Parsed UTC: $utcDateTime");
                            print("Converted IST: $istDateTime");

                            formattedDate = DateFormat(
                              'MMM dd, yyyy - hh:mm a',
                            ).format(istDateTime);
                          } catch (e) {
                            formattedDate = 'Invalid date';
                            print(
                              "Date parsing error for ride ${ride.bookingId}: $e",
                            );
                          }

                          // Determine if the arrow icon should be shown
                          bool showArrow =
                              ride.status == 'accepted' ||
                              ride.status == 'arrived' ||
                              ride.status == 'ongoing';

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.directions_car,
                                      size: 28,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${ride.vehicleType} (Booking ID: ${ride.bookingId})",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "₹${ride.fare.toStringAsFixed(2)}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontSize: 13.sp,
                                            color: Colors.grey.shade800,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        // if (showArrow) ...[
                                        //   const SizedBox(width: 8),
                                        //   GestureDetector(
                                        //     onTap: () {
                                        //       // Prepare ride data for navigation
                                        //       final rideData = {
                                        //         'ride_id': ride.id.toString(),
                                        //         'pickup_location': ride.pickup,
                                        //         'drop_location': ride.drop,
                                        //         'driver_to_pickup_km':
                                        //             ride.distanceKm.toString(),
                                        //         'pickup_to_drop_km':
                                        //             ride.distanceKm.toString(),
                                        //         'fare': ride.fare,
                                        //         'booking_id': ride.bookingId,
                                        //       };
                                        //
                                        //       // Navigate based on status
                                        //       if (ride.status == 'accepted') {
                                        //         Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //             builder:
                                        //                 (context) =>
                                        //                     ReachedPickUpLocation(
                                        //                       rideData: rideData,
                                        //                     ),
                                        //           ),
                                        //         );
                                        //       } else if (ride.status ==
                                        //           'arrived') {
                                        //         Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //             builder:
                                        //                 (context) =>
                                        //                     StartTripScreen(
                                        //                       rideData: rideData,
                                        //                       otp: ride.otp,
                                        //                     ),
                                        //           ),
                                        //         );
                                        //       } else if (ride.status ==
                                        //           'ongoing') {
                                        //         Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //             builder:
                                        //                 (context) =>
                                        //                     TripCompletedScreen(
                                        //                       rideData: rideData,
                                        //                     ),
                                        //           ),
                                        //         );
                                        //       }
                                        //     },
                                        //     child: Container(
                                        //       padding: const EdgeInsets.all(8),
                                        //       decoration: BoxDecoration(
                                        //         color: Colors.yellow.shade700,
                                        //         shape: BoxShape.circle,
                                        //       ),
                                        //       child: const Icon(
                                        //         Icons.arrow_forward,
                                        //         size: 20,
                                        //         color: Colors.white,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ],
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "From: ${ride.pickup}",
                                        style: textTheme?.copyWith(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "To: ${ride.drop}",
                                        style: textTheme?.copyWith(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "Status: ${ride.status}",
                                        style: textTheme?.copyWith(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              ride.status == 'completed'
                                                  ? primaryColor
                                                  : Colors.orange,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Date: $formattedDate",
                                            style: textTheme?.copyWith(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          if (showArrow) ...[
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                final rideData = {
                                                  'ride_id': ride.id.toString(),
                                                  'pickup_location':
                                                      ride.pickup,
                                                  'drop_location': ride.drop,
                                                  'driver_to_pickup_km':
                                                      ride.distanceKm
                                                          .toString(),
                                                  'pickup_to_drop_km':
                                                      ride.distanceKm
                                                          .toString(),
                                                  'fare': ride.fare,
                                                  'booking_id': ride.bookingId,
                                                };
                                                if (ride.status == 'accepted') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              ReachedPickUpLocation(
                                                                rideData:
                                                                    rideData,
                                                              ),
                                                    ),
                                                  );
                                                } else if (ride.status ==
                                                    'arrived') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              StartTripScreen(
                                                                rideData:
                                                                    rideData,
                                                                otp: ride.otp,
                                                              ),
                                                    ),
                                                  );
                                                } else if (ride.status ==
                                                    'ongoing') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              TripCompletedScreen(
                                                                rideData:
                                                                    rideData,
                                                              ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is RidesHistoryError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(
                      child: Text("No ride history available"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
