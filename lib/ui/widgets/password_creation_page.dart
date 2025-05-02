import 'package:firebase_crud/ui/widgets/rounded_button.dart';
import 'package:firebase_crud/ui/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PasswordCreationPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final VoidCallback onContinue;
  final VoidCallback? onGoBack;
  const PasswordCreationPage({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.onContinue,
    this.onGoBack,
  });

  @override
  State<PasswordCreationPage> createState() => _PasswordCreationPageState();
}

class _PasswordCreationPageState extends State<PasswordCreationPage> {
  bool showPassword = false;
  bool showConfirmPassword = false;
  var hasMinLength = false.obs;
  var hasNumber = false.obs;
  var hasCharacter = false.obs;

  void checkPassword(String password) {
    hasMinLength.value = password.length >= 8;
    hasNumber.value = RegExp(r'[0-9]').hasMatch(password);
    hasCharacter.value = RegExp(r'[!@#$&*~]').hasMatch(password);
  }

  double get passwordStrength {
    int score = 0;
    if (hasMinLength.value) score++;
    if (hasNumber.value) score++;
    if (hasCharacter.value) score++;
    return score / 3;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          RoundedTextField(
            title: 'Password',
            hintText: 'Enter password',
            icon:
                showPassword == true ? Icons.visibility : Icons.visibility_off,
            titleColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.grey,
            borderColor: Colors.white,
            onChanged: checkPassword,
            controller: widget.passwordController,
            obscureText: !showPassword,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              } else if (!hasMinLength.value ||
                  !hasNumber.value ||
                  !hasCharacter.value) {
                return 'Password must meet all requirements';
              }
              return null;
            },
            onIconTap: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
          SizedBox(height: 15.h),
          RoundedTextField(
            title: 'Confirm Password',
            hintText: 'Enter password again',
            icon:
                showConfirmPassword == true
                    ? Icons.visibility
                    : Icons.visibility_off,
            titleColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.grey,
            borderColor: Colors.white,
            obscureText: !showConfirmPassword,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              } else if (value != widget.passwordController.text.trim()) {
                return 'Passwords don\'t match';
              }
              return null;
            },
            onIconTap: () {
              setState(() {
                showConfirmPassword = !showConfirmPassword;
              });
            },
          ),
          SizedBox(height: 30.h),
          Obx(
            () => LinearProgressIndicator(
              value: passwordStrength,
              backgroundColor: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              valueColor: AlwaysStoppedAnimation<Color>(
                passwordStrength <= 0.33
                    ? Colors.red
                    : passwordStrength <= 0.66
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Obx(
            () => Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: hasMinLength.value ? Colors.green : Colors.grey,
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'At least 8 Characters',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: hasNumber.value ? Colors.green : Colors.grey,
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'At least 1 Number',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: hasCharacter.value ? Colors.green : Colors.grey,
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'At least 1 Special Character',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          RoundedButton(
            title: 'Finish',
            backgroundColor: Colors.orange,
            textColor: Colors.black,
            onPressed: widget.onContinue,
          ),
          if (widget.onGoBack != null)
            TextButton(
              onPressed: widget.onGoBack,
              child: Text(
                'Go Back',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
        ],
      ),
    );
  }
}
