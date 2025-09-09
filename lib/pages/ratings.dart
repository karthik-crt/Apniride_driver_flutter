import 'package:apni_ride_user/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({Key? key}) : super(key: key);

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  double overallRating = 4.8;
  int totalReviews = 123;

  List<Map<String, dynamic>> ratingDistribution = [
    {"label": "5", "percent": 0.84, "value": "84%"},
    {"label": "4", "percent": 0.10, "value": "10%"},
    {"label": "3", "percent": 0.03, "value": "3%"},
    {"label": "2", "percent": 0.01, "value": "1%"},
    {"label": "1", "percent": 0.02, "value": "2%"},
  ];

  List<Map<String, String>> feedbacks = [
    {
      "name": "Rohan",
      "time": "1 weeks ago",
      "feedback":
          "Mani was a great driver, very friendly and professional. The car was clean and comfortable, and the ride was smooth. I would definitely recommend him to others.",
      "img": "assets/images/person1.png",
    },
    {
      "name": "Mahima",
      "time": "2 weeks ago",
      "feedback":
          "Santhosh was a good driver, but the car was a bit messy. The ride was smooth, but the music was a bit loud. Overall, it was a decent experience.",
      "img": "assets/images/person2.png",
    },
  ];

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
  ) {
    return Card(
      color: Color(0xFFFAFAFA),
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
                (index) =>
                    const Icon(Icons.star, color: Colors.amber, size: 18),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              feedback,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Color(0xFF5A5A5A),
                fontSize: 13.sp,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
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
          color: Color(0xFFBEEFE2),
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
      body: ListView(
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
                    overallRating.toString(),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) =>
                          Icon(Icons.star, color: Colors.amber, size: 20),
                    ),
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
                              r["label"],
                              r["percent"],
                              r["value"],
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

          // Feedback Cards
          ...feedbacks.map(
            (f) => _buildFeedbackCard(
              f["name"]!,
              f["time"]!,
              f["feedback"]!,
              f["img"]!,
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
              _buildSummaryCard("Total Rides", "347", color: primaryColor),
              _buildSummaryCard(
                "Completion Rate",
                "98.8%",
                color: Colors.green,
              ),
            ],
          ),

          // Average Trip Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFBEEFE2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(
                      "Average Trip Time",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                    ),
                  ],
                ),
                Text(
                  "22 min",
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFBEEFE2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(
                      "Top Destination",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                    ),
                  ],
                ),
                Text(
                  "Downtown",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Weekly Growth
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFBEEFE2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.show_chart, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(
                      "Weekly Growth",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                    ),
                  ],
                ),
                Text(
                  "+12.5%",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
