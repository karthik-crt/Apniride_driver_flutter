import 'package:apni_ride_user/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);

  @override
  State<Earnings> createState() => _EarningsDashboardScreenState();
}

class _EarningsDashboardScreenState extends State<Earnings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildCard(String icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.teal.shade700,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SvgPicture.asset(icon, height: 15.h, width: 15.w),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(height: 5.h),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 19.sp,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Dashboard",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryColor),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: "Daily"),
                  Tab(text: "Weekly"),
                  Tab(text: "Monthly"),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView(
              children: [
                _buildCard(
                  "assets/images/earning.svg",
                  "Total Earnings",
                  "₹2000.00",
                ),
                _buildCard("assets/images/rides.svg", "No. of Rides", "12"),
                _buildCard(
                  "assets/images/earning.svg",
                  "Wallet Balance",
                  "₹1000.00",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
