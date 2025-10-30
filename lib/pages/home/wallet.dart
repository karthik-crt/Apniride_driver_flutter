import 'package:apni_ride_user/bloc/Wallet/wallet_cubit.dart';
import 'package:apni_ride_user/bloc/Withdraw/withdraw_cubit.dart';
import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/routes/app_routes.dart';
import 'package:apni_ride_user/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

import '../../bloc/Wallet/wallet.state.dart';
import '../../bloc/Withdraw/withdraw_state.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _upiIdController = TextEditingController();
  final _withdrawalAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RazorpayPaymentCubit>().getWalletBalance();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _upiIdController.dispose();
    _withdrawalAmountController.dispose();
    super.dispose();
  }

  String? _validateAccountNumber(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Account number is required';
    }
    if (!RegExp(r'^\d{9,18}$').hasMatch(value.toString())) {
      return 'Enter a valid account number (9-18 digits)';
    }
    return null;
  }

  // Validation for UPI ID
  String? _validateUpiId(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'UPI ID is required';
    }
    if (!RegExp(
      r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$',
    ).hasMatch(value.toString())) {
      return 'Enter a valid UPI ID (e.g., example@upi)';
    }
    return null;
  }

  // Validation for Withdrawal Amount
  String? _validateWithdrawalAmount(dynamic value, double availableBalance) {
    if (value == null || value.toString().isEmpty) {
      return 'Withdrawal amount is required';
    }
    final amount = double.tryParse(value.toString());
    if (amount == null || amount < 100) {
      return 'Minimum withdrawal amount is ₹100';
    }
    if (amount > availableBalance) {
      return 'Withdrawal amount cannot exceed available balance';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RazorpayPaymentCubit, RazorpayPaymentState>(
      listener: (context, state) {
        if (state is RazorpayPaymentFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        String balance = "₹0.00";
        double availableBalance = 0.0;
        if (state is RazorpayPaymentWalletFetched) {
          balance = "₹${state.wallet.data.balance ?? '0.00'}";
          availableBalance = double.parse(state.wallet.data.balance ?? '0.00');
        } else if (state is RazorpayPaymentLoading) {
          balance = "Loading...";
        }

        return BlocConsumer<WithdrawCubit, WithdrawState>(
          listener: (context, withdrawState) {
            if (withdrawState is WithdrawSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(withdrawState.withdrawDatas.StatusMessage),
                ),
              );
              // Refresh wallet balance after successful withdrawal
              context.read<RazorpayPaymentCubit>().getWalletBalance();
              // Clear form fields
              _accountNumberController.clear();
              _upiIdController.clear();
              _withdrawalAmountController.clear();
            } else if (withdrawState is WithdrawError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(withdrawState.message)));
            }
          },
          builder: (context, withdrawState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              // Prevent resize when keyboard appears
              appBar: AppBar(
                titleSpacing: 20.0,
                title: Text(
                  "Wallet & Withdrawal",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.addWallet);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        "Add Wallet",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                balance,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.sp,
                                ),
                              ),
                              Text(
                                "Available balance",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Bank Account Number",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                        ),
                        SizedBox(height: 5.h),
                        CustomTextFormField(
                          controller: _accountNumberController,
                          hintText: "Account number",
                          marginHorizontal: 0,
                          validator: _validateAccountNumber,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "UPI ID",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                        ),
                        SizedBox(height: 5.h),
                        CustomTextFormField(
                          controller: _upiIdController,
                          hintText: "UPI ID",
                          marginHorizontal: 0,
                          validator: _validateUpiId,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Withdrawal Amount",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
                        ),
                        SizedBox(height: 5.h),
                        CustomTextFormField(
                          controller: _withdrawalAmountController,
                          hintText: "Withdrawal amount",
                          marginHorizontal: 0,
                          validator:
                              (value) => _validateWithdrawalAmount(
                                value,
                                availableBalance,
                              ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Minimum withdrawal: ₹100",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Add padding to ensure button is visible
                        Container(
                          margin: EdgeInsets.only(
                            top: 15.h,
                            right: 15.w,
                            left: 15.w,
                          ),
                          width: MediaQuery.sizeOf(context).width,
                          height: 45.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                RoundedRectangleBorder
                              >(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed:
                                withdrawState is WithdrawLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        // Prepare data for withdrawal
                                        final data = ({
                                          'account_number':
                                              _accountNumberController.text,
                                          'upi_id': _upiIdController.text,
                                          'amount':
                                              _withdrawalAmountController.text,
                                        });
                                        context.read<WithdrawCubit>().withdraw(
                                          data,
                                          context,
                                        );
                                      }
                                    },
                            child: Text(
                              withdrawState is WithdrawLoading
                                  ? "Processing..."
                                  : "Withdraw now",
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).viewInsets.bottom + 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
