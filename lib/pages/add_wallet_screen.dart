import 'package:apni_ride_user/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../bloc/Wallet/wallet_cubit.dart';
import '../bloc/Wallet/wallet.state.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<int> _presetAmounts = [100, 200, 500];
  int? _selectedAmount;
  late Razorpay _razorpay;
  double? _currentAmount;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  void _onPresetTap(int amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  void _onAddWallet() {
    final enteredText = _amountController.text.trim();
    if (enteredText.isEmpty) {
      _showSnackBar("Please enter or select an amount");
      return;
    }
    final amount = double.tryParse(enteredText);
    if (amount == null || amount <= 0) {
      _showSnackBar("Enter a valid amount");
      return;
    }
    _currentAmount = amount;

    final options = {
      'key': 'rzp_test_RWneIBNQYQoNVc',
      'amount': (amount * 100).toInt(),
      'name': 'ApniRide',
      'description': 'Add money to wallet',
      //'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Call addWallet API only on payment success
    context.read<RazorpayPaymentCubit>().addWalletAmount(_currentAmount!);
    _showSnackBar("Payment Successful!");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do not call addWallet API on failure
    _showSnackBar("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showSnackBar("External Wallet Selected: ${response.walletName}");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RazorpayPaymentCubit, RazorpayPaymentState>(
      listener: (context, state) {
        if (state is RazorpayPaymentSuccess) {
          // After addWallet API success, fetch updated wallet balance
          context.read<RazorpayPaymentCubit>().getWalletBalance();
          Navigator.pop(context);
        } else if (state is RazorpayPaymentFailure) {
          _showSnackBar(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            title: Text(
              "Add your Wallet",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Amount",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      _presetAmounts.map((amount) {
                        return ChoiceChip(
                          label: Text("₹$amount"),
                          selected: _selectedAmount == amount,
                          onSelected: (_) => _onPresetTap(amount),
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            color:
                                _selectedAmount == amount
                                    ? Colors.white
                                    : Colors.green.shade700,
                          ),
                        );
                      }).toList(),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Enter Custom Amount",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: "₹ ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Enter amount",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedAmount = null;
                    });
                  },
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 45.h,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed:
                        state is RazorpayPaymentLoading ? null : _onAddWallet,
                    child:
                        state is RazorpayPaymentLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              "Add Wallet",
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 15.sp,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
