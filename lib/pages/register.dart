import 'dart:io';
import 'package:apni_ride_user/bloc/Register/register_cubit.dart';
import 'package:apni_ride_user/bloc/Register/register_state.dart';
import 'package:apni_ride_user/model/get_vehicle_types.dart';
import 'package:apni_ride_user/utills/shared_preference.dart';
import 'package:apni_ride_user/widgets/custom_form_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/GetVehicles/get_vehicle_cubit.dart';
import '../bloc/GetVehicles/get_vehicle_state.dart';
import '../routes/app_routes.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final modelController = TextEditingController();
  final plateController = TextEditingController();
  final stateController = TextEditingController();
  final drivingLicenseController = TextEditingController();
  final rcBookController = TextEditingController();
  final aadhaarController = TextEditingController();
  final panCardController = TextEditingController();
  bool isChecked = false;
  File? drivingLicense;
  File? rcBook;
  File? aadhaar;
  File? panCard;
  bool isLoading = false;
  String? selectedVehicleType;

  // Future<File?> _pickImage(BuildContext context) async {
  //   final picker = ImagePicker();
  //
  //   final pickedFile = await showDialog<XFile?>(
  //     context: context,
  //     builder:
  //         (ctx) => AlertDialog(
  //           title: const Text("Choose Option"),
  //           actions: [
  //             TextButton(
  //               onPressed: () async {
  //                 if (await Permission.camera.request().isGranted) {
  //                   final file = await picker.pickImage(
  //                     source: ImageSource.camera,
  //                   );
  //                   Navigator.pop(ctx, file);
  //                 } else {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(content: Text("Camera permission denied")),
  //                   );
  //                   Navigator.pop(ctx);
  //                 }
  //               },
  //               child: const Text("Camera"),
  //             ),
  //             TextButton(
  //               onPressed: () async {
  //                 PermissionStatus status;
  //
  //                 if (Platform.isAndroid) {
  //                   if (await Permission.photos.isGranted ||
  //                       await Permission.photos.isLimited) {
  //                     status = PermissionStatus.granted;
  //                   } else {
  //                     if (Platform.isAndroid &&
  //                         (await Permission.storage.request()).isGranted) {
  //                       status = PermissionStatus.granted;
  //                     } else {
  //                       status = PermissionStatus.denied;
  //                     }
  //                   }
  //                 } else {
  //                   // iOS: use photos permission
  //                   status = await Permission.photos.request();
  //                 }
  //
  //                 if (status.isGranted) {
  //                   final file = await picker.pickImage(
  //                     source: ImageSource.gallery,
  //                   );
  //                   Navigator.pop(ctx, file);
  //                 } else {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       content: Text("Gallery permission denied"),
  //                     ),
  //                   );
  //                   Navigator.pop(ctx);
  //                 }
  //               },
  //               child: const Text("Gallery"),
  //             ),
  //           ],
  //         ),
  //   );
  //
  //   return pickedFile != null ? File(pickedFile.path) : null;
  // }
  Future<File?> pickImage(BuildContext context) async {
    final picker = ImagePicker();

    // Helper to request gallery permission correctly
    Future<PermissionStatus> _requestGalleryPermission() async {
      if (Platform.isAndroid) {
        if (await Permission.photos.isGranted ||
            await Permission.photos.isLimited) {
          return PermissionStatus.granted;
        }

        // Android 13+ uses READ_MEDIA_IMAGES
        if (Platform.isAndroid && (await Permission.storage.isGranted)) {
          return PermissionStatus.granted;
        }

        // Request the appropriate permission
        if (Platform.isAndroid &&
            (await Permission.photos.request()).isGranted) {
          return PermissionStatus.granted;
        }
        if (Platform.isAndroid &&
            (await Permission.storage.request()).isGranted) {
          return PermissionStatus.granted;
        }

        return PermissionStatus.denied;
      } else {
        // iOS
        return await Permission.photos.request();
      }
    }

    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Choose Option"),
            actions: [
              // Camera
              TextButton(
                onPressed: () async {
                  final status = await Permission.camera.request();
                  if (status.isGranted) {
                    final file = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    Navigator.pop(ctx, file);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Camera permission denied")),
                    );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text("Camera"),
              ),

              // Gallery
              TextButton(
                onPressed: () async {
                  final status = await _requestGalleryPermission();
                  if (status.isGranted) {
                    final file = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    Navigator.pop(ctx, file);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Gallery permission denied"),
                      ),
                    );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text("Gallery"),
              ),
            ],
          ),
    );

    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Widget _uploadField(
    String label,
    File? file,
    Function(File) onPicked,
    TextEditingController controller,
  ) {
    return CustomTextFormField(
      hintText: label,
      marginHorizontal: 0,
      readOnly: true,
      controller: controller,
      suffixIcon: InkWell(
        onTap: () async {
          print("Tap here: $label");
          final img = await pickImage(context);
          if (img != null) {
            setState(() {
              onPicked(img);
              controller.text = "${img.path.split('/').last}";
            });
          }
        },
        splashColor: Colors.blue.withOpacity(0.2),
        highlightColor: Colors.blue.withOpacity(0.1),
        child: const Icon(Icons.upload_outlined, size: 20, color: Colors.grey),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (!isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please check vehicle inspection")),
        );
        return;
      }
      if (selectedVehicleType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select vehicle type")),
        );
        return;
      }
      final formData = FormData.fromMap({
        'mobile': mobileController.text,
        'username': nameController.text,
        'email': emailController.text,
        'vehicle_type': selectedVehicleType,
        'model': modelController.text,
        'plate_number': plateController.text,
        'state': stateController.text,
        "fcm_token": SharedPreferenceHelper.getFcmToken(),
        if (drivingLicense != null)
          'driving_license': await MultipartFile.fromFile(
            drivingLicense!.path,
            filename: drivingLicense!.path.split('/').last,
          ),
        if (rcBook != null)
          'rc_book': await MultipartFile.fromFile(
            rcBook!.path,
            filename: rcBook!.path.split('/').last,
          ),
        if (aadhaar != null)
          'aadhaar': await MultipartFile.fromFile(
            aadhaar!.path,
            filename: aadhaar!.path.split('/').last,
          ),
        if (panCard != null)
          'pan_card': await MultipartFile.fromFile(
            panCard!.path,
            filename: panCard!.path.split('/').last,
          ),
      });
      context.read<RegisterCubit>().register(formData, context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    modelController.dispose();
    plateController.dispose();
    stateController.dispose();
    drivingLicenseController.dispose();
    rcBookController.dispose();
    aadhaarController.dispose();
    panCardController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<GetVehicleCubit>().getVehicleTypes();
    mobileController.text = SharedPreferenceHelper.getMobile() ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is RegisterSuccess) {
          SharedPreferenceHelper.setToken(state.registerData.access);
          SharedPreferenceHelper.setId(state.registerData.id);
          print(
            "tokentoken ${SharedPreferenceHelper.getToken()} ${SharedPreferenceHelper.getId()}",
          );
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.registerData.statusMessage)),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        } else if (state is RegisterError) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 35.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Driver Registration",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 24.sp),
                ),
                SizedBox(height: 10.h),

                /// Name
                CustomTextFormField(
                  hintText: "Full Name",
                  marginHorizontal: 0,
                  controller: nameController,
                  validator:
                      (val) =>
                          val == null || val.isEmpty ? "Enter your name" : null,
                ),

                /// Mobile
                CustomTextFormField(
                  hintText: "Mobile Number",
                  marginHorizontal: 0,
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return "Enter mobile number";
                    if (val.length != 10) return "Enter valid 10-digit number";
                    return null;
                  },
                ),

                /// Email
                CustomTextFormField(
                  hintText: "Email ID",
                  marginHorizontal: 0,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter email";
                    if (!RegExp(
                      r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$",
                    ).hasMatch(val)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15.h),

                /// Document Uploads
                Text(
                  "Document Uploads",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 10.h),

                _uploadField(
                  "Driving License",
                  drivingLicense,
                  (f) => drivingLicense = f,
                  drivingLicenseController,
                ),
                _uploadField(
                  "RC Book",
                  rcBook,
                  (f) => rcBook = f,
                  rcBookController,
                ),
                _uploadField(
                  "Aadhaar",
                  aadhaar,
                  (f) => aadhaar = f,
                  aadhaarController,
                ),
                _uploadField(
                  "PAN Card",
                  panCard,
                  (f) => panCard = f,
                  panCardController,
                ),

                SizedBox(height: 15.h),

                /// Vehicle Info
                Text(
                  "Vehicle Information",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 10.h),

                BlocBuilder<GetVehicleCubit, GetVehicleState>(
                  builder: (context, state) {
                    if (state is GetVehicleLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetVehicleSuccess) {
                      final vehicles = state.getVehicles.vehicleTypes;
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: "Vehicle Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                        value: selectedVehicleType,
                        onChanged: (value) {
                          setState(() {
                            selectedVehicleType = value;
                          });
                        },
                        items:
                            vehicles
                                .map(
                                  (v) => DropdownMenuItem<String>(
                                    value: v.name,
                                    child: Text(v.name),
                                  ),
                                )
                                .toList(),
                        validator:
                            (val) => val == null ? "Select vehicle type" : null,
                      );
                    } else if (state is GetVehicleError) {
                      print("ErrorError");
                      return Text(
                        "Error loading vehicle types: ${state.message}",
                        style: const TextStyle(color: Colors.red),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                CustomTextFormField(
                  hintText: "Model",
                  marginHorizontal: 0,
                  controller: modelController,
                  validator:
                      (val) =>
                          val == null || val.isEmpty ? "Enter model" : null,
                ),
                CustomTextFormField(
                  hintText: "Plate Number",
                  marginHorizontal: 0,
                  controller: plateController,
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? "Enter plate number"
                              : null,
                ),
                CustomTextFormField(
                  hintText: "State",
                  marginHorizontal: 0,
                  controller: stateController,
                  validator:
                      (val) =>
                          val == null || val.isEmpty ? "Enter state" : null,
                ),

                SizedBox(height: 10.h),

                /// Checkbox
                Row(
                  children: [
                    Checkbox(
                      side: BorderSide(color: Colors.grey.shade500),
                      value: isChecked,
                      onChanged:
                          (value) => setState(() => isChecked = value ?? false),
                    ),
                    Text(
                      "Vehicle Inspection",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                /// Submit
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 45.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isLoading ? null : _submit,
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              "Submit",
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
        ),
      ),
    );
  }
}
