import 'package:apni_ride_user/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> notifications = [
    {
      "title": "Route Update Available",
      "subtitle":
          "A more efficient route has been found for your next delivery. Estimated 5 minutes faster.",
      "time": "2 minutes ago",
      "icon": "route",
    },
    {
      "title": "Traffic Alert",
      "subtitle":
          "Heavy traffic detected on Highway 101. Consider taking alternate route via Main Street.",
      "time": "8 minutes ago",
      "icon": "traffic",
    },
    {
      "title": "Delivery Completed",
      "subtitle":
          "Order #2847 has been successfully delivered to 123 Oak Street. Customer rating: 5 stars",
      "time": "1 hour ago",
      "icon": "done",
    },
    {
      "title": "Scheduled Maintenance",
      "subtitle":
          "System maintenance is scheduled for tonight from 2:00 AM to 4:00 AM. Service may be temporarily unavailable.",
      "time": "3 hour ago",
      "icon": "info",
    },
    {
      "title": "Connection Issue",
      "subtitle":
          "GPS connection lost. Please check your device settings and ensure location services are enabled.",
      "time": "6 hour ago",
      "icon": "gps",
    },
  ];

  Widget _getIcon(String type) {
    switch (type) {
      case "route":
        return SvgPicture.asset(
          'assets/images/warning.svg',
          height: 35,
          width: 38,
        );
      case "traffic":
        return SvgPicture.asset(
          'assets/images/info.svg',
          height: 35,
          width: 38,
        );
      case "done":
        return SvgPicture.asset(
          'assets/images/success.svg',
          height: 35,
          width: 38,
        );
      case "info":
        return SvgPicture.asset(
          'assets/images/warning.svg',
          height: 35,
          width: 38,
        );
      case "gps":
        return SvgPicture.asset(
          'assets/images/info.svg',
          height: 35,
          width: 38,
        );
      default:
        return const Icon(Icons.notifications, color: Colors.grey, size: 22);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          "Notification",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return ListTile(
            visualDensity: VisualDensity(horizontal: -3),
            leading: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: _getIcon(item["icon"]!),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item["title"]!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  item["time"]!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              item["subtitle"]!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: 10.sp,
              ),
            ),
            // trailing:
            // Text(
            //   item["time"]!,
            //   style: const TextStyle(fontSize: 12, color: Colors.grey),
            // ),
          );
        },
      ),
    );
  }
}
