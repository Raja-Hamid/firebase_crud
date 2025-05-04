import 'package:firebase_crud/controllers/routes/app_routes.dart';
import 'package:firebase_crud/ui/screens/sign_up_with_phone_number_screens.dart';
import 'package:firebase_crud/ui/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crud/constants/colors.dart';
import 'package:firebase_crud/ui/widgets/rounded_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Create a new Account',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                      'Start by creating a free account to effortlessly manage your data with the App.',
                      style: TextStyle(color: Colors.white, fontSize: 17.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.h),
                    RoundedButton(
                      title: 'Continue with email',
                      backgroundColor: Colors.orange,
                      textColor: Colors.black,
                      onPressed: () {
                        Get.toNamed(AppRoutes.signUpWithEmailScreens);
                      },
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'or',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    RoundedButton(
                      title: 'Continue with Phone',
                      backgroundColor: Colors.transparent,
                      textColor: Colors.white,
                      borderColor: Colors.grey,
                      icon: 'assets/icons/phone.svg',
                      onPressed: () {
                        Get.to(const SignUpWithPhoneNumberScreens());
                      },
                    ),
                    SizedBox(height: 15.h),
                    RoundedButton(
                      title: 'Continue with Apple',
                      backgroundColor: Colors.transparent,
                      textColor: Colors.white,
                      borderColor: Colors.grey,
                      icon: 'assets/icons/apple.svg',
                      onPressed: () {},
                    ),
                    SizedBox(height: 15.h),
                    RoundedButton(
                      title: 'Continue with Facebook',
                      backgroundColor: Colors.transparent,
                      textColor: Colors.white,
                      borderColor: Colors.grey,
                      icon: 'assets/icons/facebook.svg',
                      onPressed: () {},
                    ),
                    SizedBox(height: 15.h),
                    RoundedButton(
                      title: 'Continue with Google',
                      backgroundColor: Colors.transparent,
                      textColor: Colors.white,
                      borderColor: Colors.grey,
                      icon: 'assets/icons/google.svg',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
