import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.h),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'By using Firebase CRUD, you agree to our\n',
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            TextSpan(
              text: ' and ',
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            TextSpan(
              text: '.',
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
