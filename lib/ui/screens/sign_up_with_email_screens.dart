import 'package:firebase_crud/constants/colors.dart';
import 'package:firebase_crud/constants/validators.dart';
import 'package:firebase_crud/controllers/auth/auth_controller.dart';
import 'package:firebase_crud/controllers/page_controllers/page_navigation_controller.dart';
import 'package:firebase_crud/ui/widgets/carousel_indicator.dart';
import 'package:firebase_crud/ui/widgets/custom_footer.dart';
import 'package:firebase_crud/ui/widgets/email_verification_page.dart';
import 'package:firebase_crud/ui/widgets/password_creation_page.dart';
import 'package:firebase_crud/ui/widgets/personal_details_page.dart';
import 'package:firebase_crud/ui/widgets/rounded_button.dart';
import 'package:firebase_crud/ui/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpWithEmailScreens extends StatefulWidget {
  const SignUpWithEmailScreens({super.key});

  @override
  State<SignUpWithEmailScreens> createState() => _SignUpWithEmailScreensState();
}

class _SignUpWithEmailScreensState extends State<SignUpWithEmailScreens> {
  final _emailFormKey = GlobalKey<FormState>();
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
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
              'Add your Email',
              'Verify your Email',
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
                      page = _buildAddEmailPage();
                      break;
                    case 1:
                      page = _buildEmailVerificationPage();
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

  Widget _buildAddEmailPage() {
    return Form(
      key: _emailFormKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
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
          SizedBox(height: 30.h),
          RoundedButton(
            title: 'Continue',
            backgroundColor: Colors.orange,
            textColor: Colors.black,
            onPressed: () async {
              if (_emailFormKey.currentState!.validate()) {
                _authController.sendVerificationEmail(
                  email: _emailController.text.trim(),
                );
                _controller.nextPage();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmailVerificationPage() {
    return EmailVerificationPage(
      email: _emailController.text.trim(),
      onContinue: _controller.nextPage,
      onGoBack: _controller.previousPage,
      authController: _authController,
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
        if (_passwordFormKey.currentState!.validate()) {
          _authController.signUp(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            dateOfBirth: _dobController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        }
      },
      onGoBack: _controller.previousPage,
    );
  }
}
