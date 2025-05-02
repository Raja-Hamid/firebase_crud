import 'package:firebase_crud/constants/colors.dart';
import 'package:firebase_crud/controllers/auth/auth_controller.dart';
import 'package:firebase_crud/ui/widgets/password_creation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NewPasswordScreen extends StatefulWidget {
  final String oobCode;
  const NewPasswordScreen({super.key, required this.oobCode});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
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
          'Create new Password',
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
                child: PasswordCreationPage(
                  formKey: _formKey,
                  passwordController: _passwordController,
                  onContinue: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.updatePassword(
                        oobCode: widget.oobCode,
                        password: _passwordController.text.trim(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
