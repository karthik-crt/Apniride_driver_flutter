import 'package:apni_ride_user/bloc/WalletHistory/wallet_history_cubit.dart';
import 'package:apni_ride_user/bloc/WalletHistory/wallet_history_state.dart';
import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/model/WalletHistory_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletHistoryCubit>().getWalletHistory();
  }

  Future<void> _onRefresh() async {
    await context.read<WalletHistoryCubit>().getWalletHistory();
  }

  String formatDate(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    DateTime local = dateTime.toLocal();
    return DateFormat('MMMM d, yyyy, h:mm a').format(local);
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
                child: BlocBuilder<WalletHistoryCubit, WalletHistoryState>(
                  builder: (context, state) {
                    if (state is WalletHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WalletHistorySuccess) {
                      final wallet = state.walletHistory;
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(16.w),
                        children: [
                          Text(
                            'Driver: ${wallet.data.driver}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Current Balance: ₹${wallet.data.currentBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Transactions',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ...wallet.data.transactions.map((tx) {
                            final isWithdrawal =
                                tx.transactionType == 'withdrawal';
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          tx.description,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '₹${tx.amount}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontSize: 13.sp,
                                          color:
                                              isWithdrawal
                                                  ? Colors.red
                                                  : Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Type: ${tx.transactionType}',
                                    style: textTheme?.copyWith(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Balance After: ₹${tx.balanceAfter}',
                                    style: textTheme?.copyWith(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Date: ${formatDate(tx.createdAt)}',
                                    style: textTheme?.copyWith(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (tx.rideId.isNotEmpty) ...[
                                    Text(
                                      'Ride ID: ${tx.rideId}',
                                      style: textTheme?.copyWith(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                  const Divider(),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    } else if (state is WalletHistoryError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text("No data available"));
                    }
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
