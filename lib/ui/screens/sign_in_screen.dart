import 'package:firebase_crud/constants/colors.dart';
import 'package:firebase_crud/constants/validators.dart';
import 'package:firebase_crud/controllers/auth/auth_controller.dart';
import 'package:firebase_crud/controllers/routes/app_routes.dart';
import 'package:firebase_crud/ui/widgets/custom_footer.dart';
import 'package:firebase_crud/ui/widgets/rounded_button.dart';
import 'package:firebase_crud/ui/widgets/rounded_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Sign into your Account',
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
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      RoundedTextField(
                        title: 'Email',
                        hintText: 'Enter email',
                        titleColor: Colors.white,
                        textColor: Colors.white,
                        hintColor: Colors.grey,
                        borderColor: Colors.white,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          final regExp = RegExp(kEmailRegex);
                          if (!regExp.hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      RoundedTextField(
                        title: 'Password',
                        hintText: 'Enter password',
                        icon:
                            showPassword == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                        titleColor: Colors.white,
                        textColor: Colors.white,
                        hintColor: Colors.grey,
                        borderColor: Colors.white,
                        controller: _passwordController,
                        obscureText: !showPassword,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        onIconTap: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                      SizedBox(height: 30.h),
                      RoundedButton(
                        title: 'Sign In',
                        backgroundColor: Colors.orange,
                        textColor: Colors.black,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _authController.signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Forgot Password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.resetPasswordScreen);
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
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
