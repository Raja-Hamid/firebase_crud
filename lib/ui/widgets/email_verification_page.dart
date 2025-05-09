import 'dart:async';
import 'package:firebase_crud/controllers/auth/auth_controller.dart';
import 'package:firebase_crud/ui/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  final VoidCallback onContinue;
  final VoidCallback onGoBack;
  final AuthController authController;
  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.onContinue,
    required this.onGoBack,
    required this.authController,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  RxBool isVerified = false.obs;
  Timer? _deletionTimer;

  @override
  void initState() {
    super.initState();
    _deletionCountdown();
  }

  void _deletionCountdown() {
    _deletionTimer = Timer(const Duration(seconds: 25), () {
      widget.authController.deleteAccount();
      widget.authController.resetEmailVerification();
    });
  }

  @override
  void dispose() {
    _deletionTimer?.cancel();
    widget.authController.resetEmailVerification();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(height: 30.h),
        Icon(Icons.mark_email_read_rounded, color: Colors.orange, size: 80.sp),
        SizedBox(height: 30.h),
        Text(
          'Please click the verification link sent to ${widget.email} to verify that\nits yours.',
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.h),
        Obx(() {
          final verified = widget.authController.isEmailVerified.value;
          return RoundedButton(
            title: 'Continue',
            backgroundColor: verified ? Colors.orange : Colors.grey,
            textColor: Colors.black,
            onPressed: verified ? widget.onContinue : () {},
          );
        }),
        TextButton(
          onPressed: widget.onGoBack,
          child: Text(
            'Go Back',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ),
      ],
    );
  }
}
