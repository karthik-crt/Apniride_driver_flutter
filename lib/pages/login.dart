import 'package:apni_ride_user/config/constant.dart';
import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:apni_ride_user/widgets/custom_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../bloc/Login/login_cubit.dart';
import '../bloc/Login/login_state.dart';
import '../routes/app_routes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isOTPVerified = false;
  final TextEditingController mobile = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String? enteredPhoneNumber;
  bool isLoading = false;
  final String staticOTP = "123456";

  @override
  void initState() {
    super.initState();
    otpController.text = staticOTP;
  }

  @override
  void dispose() {
    mobile.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (state.login.statusCode == '1') {
            print("Yes old user");
            print("Yes old user");
            if (state.login.isOldUser) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            } else {
              SharedPreferenceHelper.setMobile(mobile.text);
              print("Mobile : ${SharedPreferenceHelper.getMobile()}");
              setState(() {
                isLoading = false;
                isOTPVerified = true;
              });
            }
          }
        } else if (state is LoginError) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomNavigationBar:
              isOTPVerified
                  ? Container(
                    margin: EdgeInsets.only(top: 15.h, right: 15.w, left: 15.w),
                    width: MediaQuery.sizeOf(context).width,
                    height: 45.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                      ),
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                // Navigate to register screen after clicking Verify
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                );
                              },
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                "Verify",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                    ),
                  )
                  : null,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 35.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    if (!isOTPVerified) {
                      Navigator.of(context).pop();
                    }
                    setState(() {
                      if (isOTPVerified) {
                        isOTPVerified = false;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_sharp, size: 20),
                      SizedBox(width: 5.w),
                      Text(
                        "Back",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading || isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return !isOTPVerified ? buildLogin() : buildOTP();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login Now",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 18.sp),
        ),
        SizedBox(height: 3.h),
        Text(
          "Hi, Welcome back to the riders",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 13.sp,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: 10.h),
        CustomTextFormField(
          hintText: "Phone number",
          marginHorizontal: 0,
          controller: mobile,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Phone number is required";
            } else if (value.length != 10) {
              return "Phone number must be exactly 10 digits";
            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return "Only numbers are allowed";
            }
            return null;
          },
        ),
        Container(
          margin: EdgeInsets.only(top: 15.h),
          width: MediaQuery.sizeOf(context).width,
          height: 45.h,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            onPressed:
                isLoading
                    ? null
                    : () {
                      if (mobile.text.isNotEmpty && mobile.text.length == 10) {
                        setState(() {
                          enteredPhoneNumber = mobile.text;
                          isLoading = true;
                        });
                        context.read<LoginCubit>().login({
                          "mobile": mobile.text,
                          "fcm_token": SharedPreferenceHelper.getFcmToken(),
                        }, context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please enter a valid 10-digit phone number",
                            ),
                          ),
                        );
                      }
                    },
            child:
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                      "Login",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Colors.white, fontSize: 15.sp),
                    ),
          ),
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              text: 'Didn’t have an account? ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontSize: 15.sp,
              ),
              children: [
                TextSpan(
                  text: 'Sign up',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.teal,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOTP() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verification!",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 24.sp),
        ),
        SizedBox(height: 5.h),
        Text(
          "We have sent the code verification to your registered mobile number +91 $enteredPhoneNumber",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
        ),
        SizedBox(height: 15.h),
        Pinput(
          length: 6,
          defaultPinTheme: defaultPinTheme,
          separatorBuilder: (index) => const SizedBox(width: 8),
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          controller: otpController,
          enabled: true,
          onCompleted: (pin) {
            debugPrint('Entered OTP: $pin');
            Navigator.pushNamed(context, AppRoutes.register);
          },
          onChanged: (value) {
            debugPrint('OTP input: $value');
          },
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: primaryColor,
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Didn’t receive OTP?",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
                fontSize: 14.sp,
              ),
            ),
            GestureDetector(
              onTap:
                  isLoading
                      ? null
                      : () {
                        setState(() {
                          isLoading = true;
                        });
                        context.read<LoginCubit>().login({
                          "mobile": enteredPhoneNumber,
                          "fcm_token": SharedPreferenceHelper.getFcmToken(),
                        }, context);
                      },
              child: Text(
                "Resend OTP",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.teal,
                  fontSize: 14.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// import 'package:apni_ride_user/config/constant.dart';
// import 'package:apni_ride_user/utills/shared_preference.dart';
// import 'package:apni_ride_user/widgets/custom_form_field.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pinput/pinput.dart';
// import '../bloc/Login/login_cubit.dart';
// import '../bloc/Login/login_state.dart';
// import '../routes/app_routes.dart';
//
// class Login extends StatefulWidget {
//   const Login({super.key});
//
//   @override
//   State<Login> createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   bool isOTPVerified = false;
//   bool isOtpSuccessfullyVerified = false;
//   final TextEditingController mobile = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   String? enteredPhoneNumber;
//   bool isLoading = false;
//   String? _verificationId;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   void dispose() {
//     mobile.dispose();
//     otpController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _verifyPhoneNumber(BuildContext context) async {
//     String phoneNumber = '+91${mobile.text.trim()}';
//     if (mobile.text.length != 10 ||
//         !RegExp(r'^[0-9]+$').hasMatch(mobile.text)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a valid 10-digit phone number'),
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       enteredPhoneNumber = mobile.text;
//     });
//
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//           setState(() {
//             isOtpSuccessfullyVerified = true;
//             isLoading = false;
//           });
//           _handleSuccessfulLogin(context);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           setState(() {
//             isLoading = false;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Verification failed: ${e.message}')),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _verificationId = verificationId;
//             isOTPVerified = true; // Show OTP screen
//             isLoading = false;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId;
//         },
//       );
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }
//
//   Future<void> _verifyOtp(BuildContext context) async {
//     String otp = otpController.text.trim();
//     if (otp.isEmpty || _verificationId == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please enter the OTP')));
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: otp,
//       );
//       await _auth.signInWithCredential(credential);
//       setState(() {
//         isOtpSuccessfullyVerified = true;
//         isLoading = false;
//       });
//       _handleSuccessfulLogin(context);
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('OTP verification failed: $e')));
//
//       print(e.toString());
//     }
//   }
//
//   void _handleSuccessfulLogin(BuildContext context) {
//     context.read<LoginCubit>().login({
//       "mobile": mobile.text,
//       "fcm_token": SharedPreferenceHelper.getFcmToken(),
//     }, context);
//   }
//
//   // Resend OTP
//   Future<void> _resendOtp(BuildContext context) async {
//     await _verifyPhoneNumber(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LoginCubit, LoginState>(
//       listener: (context, state) {
//         if (state is LoginSuccess) {
//           if (state.login.statusCode == '1') {
//             if (state.login.isOldUser) {
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 AppRoutes.home,
//                 (route) => false,
//               );
//             } else if (isOtpSuccessfullyVerified) {
//               SharedPreferenceHelper.setMobile(mobile.text);
//               print("Mobile: ${SharedPreferenceHelper.getMobile()}");
//               Navigator.pushNamed(context, AppRoutes.register);
//             }
//           }
//         } else if (state is LoginError) {
//           setState(() {
//             isLoading = false;
//           });
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       child: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Scaffold(
//           bottomNavigationBar:
//               isOTPVerified
//                   ? Container(
//                     margin: EdgeInsets.only(top: 15.h, right: 15.w, left: 15.w),
//                     width: MediaQuery.sizeOf(context).width,
//                     height: 45.h,
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                       ),
//                       onPressed: isLoading ? null : () => _verifyOtp(context),
//                       child:
//                           isLoading
//                               ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                               : Text(
//                                 "Verify",
//                                 style: Theme.of(
//                                   context,
//                                 ).textTheme.headlineSmall?.copyWith(
//                                   color: Colors.white,
//                                   fontSize: 15.sp,
//                                 ),
//                               ),
//                     ),
//                   )
//                   : null,
//           body: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 35.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10.h),
//                 GestureDetector(
//                   onTap: () {
//                     if (!isOTPVerified) {
//                       Navigator.of(context).pop();
//                     }
//                     setState(() {
//                       if (isOTPVerified) {
//                         isOTPVerified = false;
//                       }
//                     });
//                   },
//                   child: Row(
//                     children: [
//                       const Icon(Icons.arrow_back_ios_sharp, size: 20),
//                       SizedBox(width: 5.w),
//                       Text(
//                         "Back",
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 18.h),
//                 BlocBuilder<LoginCubit, LoginState>(
//                   builder: (context, state) {
//                     if (state is LoginLoading || isLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     return !isOTPVerified ? buildLogin() : buildOTP();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildLogin() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Login Now",
//           style: Theme.of(
//             context,
//           ).textTheme.bodyMedium?.copyWith(fontSize: 18.sp),
//         ),
//         SizedBox(height: 3.h),
//         Text(
//           "Hi, Welcome back to the riders",
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             fontSize: 13.sp,
//             color: Colors.grey.shade500,
//           ),
//         ),
//         SizedBox(height: 10.h),
//         CustomTextFormField(
//           hintText: "Phone number",
//           marginHorizontal: 0,
//           controller: mobile,
//           keyboardType: TextInputType.phone,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Phone number is required";
//             } else if (value.length != 10) {
//               return "Phone number must be exactly 10 digits";
//             } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//               return "Only numbers are allowed";
//             }
//             return null;
//           },
//         ),
//         Container(
//           margin: EdgeInsets.only(top: 15.h),
//           width: MediaQuery.sizeOf(context).width,
//           height: 45.h,
//           child: ElevatedButton(
//             style: ButtonStyle(
//               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//             ),
//             onPressed: isLoading ? null : () => _verifyPhoneNumber(context),
//             child:
//                 isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                       "Send OTP",
//                       style: Theme.of(context).textTheme.headlineSmall
//                           ?.copyWith(color: Colors.white, fontSize: 15.sp),
//                     ),
//           ),
//         ),
//         SizedBox(height: 10.h),
//         Align(
//           alignment: Alignment.center,
//           child: RichText(
//             text: TextSpan(
//               text: 'Didn’t have an account? ',
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 color: Colors.grey.shade600,
//                 fontSize: 15.sp,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'Sign up',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     color: Colors.teal,
//                     decoration: TextDecoration.underline,
//                   ),
//                   recognizer:
//                       TapGestureRecognizer()
//                         ..onTap = () {
//                           Navigator.pushNamed(context, AppRoutes.register);
//                         },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildOTP() {
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//         fontSize: 22,
//         color: Color.fromRGBO(30, 60, 87, 1),
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade400),
//       ),
//     );
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Verification!",
//           style: Theme.of(
//             context,
//           ).textTheme.headlineMedium?.copyWith(fontSize: 24.sp),
//         ),
//         SizedBox(height: 5.h),
//         Text(
//           "We have sent the code verification to your registered mobile number +91 $enteredPhoneNumber",
//           style: Theme.of(
//             context,
//           ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
//         ),
//         SizedBox(height: 15.h),
//         Pinput(
//           length: 6,
//           defaultPinTheme: defaultPinTheme,
//           separatorBuilder: (index) => const SizedBox(width: 8),
//           hapticFeedbackType: HapticFeedbackType.lightImpact,
//           controller: otpController,
//           enabled: true,
//           onCompleted: (pin) {
//             debugPrint('Entered OTP: $pin');
//             _verifyOtp(context);
//           },
//           onChanged: (value) {
//             debugPrint('OTP input: $value');
//           },
//           cursor: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(bottom: 9),
//                 width: 22,
//                 height: 1,
//                 color: primaryColor,
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 15.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Didn’t receive OTP?",
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 color: Colors.grey.shade500,
//                 fontSize: 14.sp,
//               ),
//             ),
//             GestureDetector(
//               onTap: isLoading ? null : () => _resendOtp(context),
//               child: Text(
//                 "Resend OTP",
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   color: Colors.teal,
//                   fontSize: 14.sp,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
