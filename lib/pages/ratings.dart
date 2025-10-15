// Updated RatingsScreen

import 'package:apni_ride_user/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/FeedBacks/feedbacks_cubit.dart';
import '../bloc/FeedBacks/feedbacks_state.dart';
// Adjust path

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({Key? key}) : super(key: key);

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RatingsCubit>().getRatings(context);
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  Widget _buildRatingBar(String label, double percent, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 5),
        Expanded(
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.grey.shade300,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(
    String name,
    String time,
    String feedback,
    String img,
    int stars,
  ) {
    return Card(
      color: const Color(0xFFFAFAFA),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage(img), radius: 22),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 18,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              feedback,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5A5A5A),
                fontSize: 13.sp,
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined, size: 18),
                SizedBox(width: 5),
                Text("1"),
                SizedBox(width: 20),
                Icon(Icons.thumb_down_alt_outlined, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value, {
    Color color = Colors.teal,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFBEEFE2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: color),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
            ),
          ],
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
          icon: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Ratings",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RatingsCubit, RatingsState>(
        builder: (context, state) {
          if (state is RatingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RatingsSuccess) {
            final data = state.ratingsSummary.data;
            final overallRating = data.avgRating;
            final totalReviews = data.totalReviews;

            // Calculate distribution percentages
            final totalCounts = data.distribution.values.fold(
              0,
              (sum, count) => sum + count,
            );
            final ratingDistribution = List.generate(5, (index) {
              final label = '${5 - index}'; // 5 to 1
              final count = data.distribution[label] ?? 0;
              final percent = totalCounts > 0 ? count / totalCounts : 0.0;
              final value =
                  totalCounts > 0 ? '${(percent * 100).toInt()}%' : '0%';
              return {"label": label, "percent": percent, "value": value};
            });

            final feedbacks = data.recentFeedback;

            final totalRides = data.rideSummary.totalRides.toString();
            final completionRate =
                '${data.rideSummary.completionRate.toStringAsFixed(1)}%';
            final avgTripTime = data.rideSummary.avgTripTime ?? 'N/A';
            final topDestination = data.rideSummary.topDestination;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Your Ratings
                Text(
                  "Your Ratings",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 22.sp,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          overallRating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            if (index < overallRating.floor()) {
                              return const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              );
                            } else if (index == overallRating.floor() &&
                                (overallRating - overallRating.floor()) > 0) {
                              return const Icon(
                                Icons.star_half,
                                color: Colors.amber,
                                size: 20,
                              );
                            } else {
                              return const Icon(
                                Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }
                          }),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$totalReviews reviews",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        children:
                            ratingDistribution
                                .map(
                                  (r) => _buildRatingBar(
                                    r["label"] as String,
                                    r["percent"] as double,
                                    r["value"] as String,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Feedback",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8.h),
                if (feedbacks.isEmpty)
                  const Center(child: Text("No feedback available yet.")),
                ...feedbacks.map(
                  (f) => _buildFeedbackCard(
                    f.userName,
                    _timeAgo(f.createdAt),
                    f.feedback,
                    'assets/images/person1.png',
                    f.stars,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Ride Summaries",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 22.sp),
                ),
                const SizedBox(height: 12),
                // Ride Summary Top Row
                Row(
                  children: [
                    _buildSummaryCard(
                      "Total Rides",
                      totalRides,
                      color: primaryColor,
                    ),
                    _buildSummaryCard(
                      "Completion Rate",
                      completionRate,
                      color: Colors.green,
                    ),
                  ],
                ),
                // Average Trip Time
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBEEFE2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.black54),
                          const SizedBox(width: 10),
                          Text(
                            "Average Trip Time",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                          ),
                        ],
                      ),
                      Text(
                        avgTripTime,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Top Destination
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBEEFE2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Top Destination",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Text(
                          topDestination,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 14.sp, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is RatingsError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
