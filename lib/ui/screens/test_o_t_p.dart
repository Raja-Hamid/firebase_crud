import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/constants/colors.dart';
import 'package:firebase_crud/ui/widgets/rounded_button.dart';
import 'package:firebase_crud/ui/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TestOTP extends StatefulWidget {
  const TestOTP({super.key});

  @override
  State<TestOTP> createState() => _TestOTPState();
}

class _TestOTPState extends State<TestOTP> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendOTP() async {
    String phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      Get.snackbar("Error", "Please enter a phone number");
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto verification (optional)
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("Failed", e.message ?? "OTP failed to send");
      },
      codeSent: (String verificationId, int? resendToken) {
        Get.snackbar("Success", "OTP sent successfully!");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Enter your Phone Number',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100.h,
        iconTheme: IconThemeData(color: Colors.white, size: 25.sp),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.w),
          children: [
            RoundedTextField(
              controller: phoneController,
              title: 'Phone Number',
              hintText: 'Enter phone number',
              titleColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.grey,
              borderColor: Colors.white,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 30.h),
            RoundedButton(
              title: 'Continue',
              backgroundColor: Colors.orange,
              textColor: Colors.black,
              onPressed: sendOTP,
            ),
          ],
        ),
      ),
    );
  }
}
