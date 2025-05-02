import 'package:firebase_crud/constants/colors.dart';
import 'package:firebase_crud/controllers/auth/auth_controller.dart';
import 'package:firebase_crud/controllers/page_controllers/page_navigation_controller.dart';
import 'package:firebase_crud/ui/widgets/carousel_indicator.dart';
import 'package:firebase_crud/ui/widgets/custom_footer.dart';
import 'package:firebase_crud/ui/widgets/o_t_p_code_fields.dart';
import 'package:firebase_crud/ui/widgets/password_creation_page.dart';
import 'package:firebase_crud/ui/widgets/personal_details_page.dart';
import 'package:firebase_crud/ui/widgets/rounded_button.dart';
import 'package:firebase_crud/ui/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpWithPhoneNumberScreens extends StatefulWidget {
  const SignUpWithPhoneNumberScreens({super.key});

  @override
  State<SignUpWithPhoneNumberScreens> createState() =>
      _SignUpWithPhoneNumberScreensState();
}

class _SignUpWithPhoneNumberScreensState
    extends State<SignUpWithPhoneNumberScreens> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _otpController = List.generate(6, (_) => TextEditingController());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final _controller = Get.put(PageNavigationController());
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Obx(
          () => Text(
            [
              'Enter your Phone Number',
              'Verify OTP',
              'Enter your Personal Details',
              'Create your Password',
            ][_controller.currentPage.value],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100.h,
        iconTheme: IconThemeData(color: Colors.white, size: 25.sp),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => CarouselIndicator(
                activeColor: Colors.orange,
                inactiveColor: Colors.white,
                activeWidth: 40.w,
                inactiveWidth: 15.w,
                currentPage: _controller.currentPage.value,
                itemCount: 4,
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: PageView.builder(
                controller: _controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                onPageChanged: (value) => _controller.currentPage.value = value,
                itemBuilder: (context, index) {
                  Widget page;
                  switch (index) {
                    case 0:
                      page = _buildPhoneInputPage();
                      break;
                    case 1:
                      page = _buildOTPVerificationPage();
                      break;
                    case 2:
                      page = _buildPersonalDetailsPage();
                      break;
                    case 3:
                      page = _buildCreatePasswordPage();
                      break;
                    default:
                      page = const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: page,
                  );
                },
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInputPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        RoundedTextField(
          controller: _phoneNumberController,
          title: 'Phone Number',
          hintText: 'Enter phone number',
          titleColor: Colors.white,
          textColor: Colors.white,
          hintColor: Colors.grey,
          borderColor: Colors.white,
        ),
        SizedBox(height: 30.h),
        RoundedButton(
          title: 'Continue',
          backgroundColor: Colors.orange,
          textColor: Colors.black,
          onPressed: () {
            // _authController.signUpWithPhoneNumber(
            //   phoneNumber: _phoneNumberController.text.trim(),
            // );
            _controller.nextPage();
          },
        ),
      ],
    );
  }

  Widget _buildOTPVerificationPage() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(height: 30.h),
        Icon(Icons.sms_rounded, color: Colors.orange, size: 80.sp),
        SizedBox(height: 30.h),
        OTPCodeFields(title: 'Code', controllers: _otpController),
        SizedBox(height: 30.h),
        RoundedButton(
          title: 'Verify',
          backgroundColor: Colors.orange,
          textColor: Colors.black,
          onPressed: () {
            // final code = _otpControllers.map((c) => c.text).join();
            // _controller.verifyOTP(code);
            _controller.nextPage();
          },
        ),
        TextButton(
          onPressed: _controller.previousPage,
          child: Text(
            'Go Back',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalDetailsPage() {
    return PersonalDetailsPage(
      formKey: _profileFormKey,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      dobController: _dobController,
      onContinue: () {
        if (_profileFormKey.currentState!.validate()) {
          _controller.nextPage();
        }
      },
      onBack: _controller.previousPage,
      onPickImage: () {},
    );
  }

  Widget _buildCreatePasswordPage() {
    return PasswordCreationPage(
      formKey: _passwordFormKey,
      passwordController: _passwordController,
      onContinue: () {
        if (_passwordFormKey.currentState!.validate()) {}
      },
      onGoBack: _controller.previousPage,
    );
  }
}
