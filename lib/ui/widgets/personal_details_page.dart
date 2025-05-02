import 'package:firebase_crud/ui/widgets/date_picker_text_field.dart';
import 'package:firebase_crud/ui/widgets/rounded_button.dart';
import 'package:firebase_crud/ui/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalDetailsPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onPickImage;
  const PersonalDetailsPage({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.dobController,
    required this.onContinue,
    required this.onBack,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      // backgroundImage: _profileImage != null
                      //     ? FileImage(_profileImage!)
                      //     : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                      backgroundColor: Colors.black,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Text(
                  'Profile Picture',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          RoundedTextField(
            title: 'First Name',
            hintText: 'Enter first name',
            titleColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.grey,
            borderColor: Colors.white,
            controller: firstNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'First Name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 15.h),
          RoundedTextField(
            title: 'Last Name',
            hintText: 'Enter last name',
            titleColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.grey,
            borderColor: Colors.white,
            controller: lastNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Last Name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 15.h),
          DatePickerTextField(
            title: 'Date of Birth',
            hintText: 'Select Date of Birth',
            titleColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.grey,
            borderColor: Colors.white,
            icon: Icons.calendar_month,
            controller: dobController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Date of Birth is required';
              }
              return null;
            },
          ),
          SizedBox(height: 30.h),
          RoundedButton(
            title: 'Continue',
            backgroundColor: Colors.orange,
            textColor: Colors.black,
            onPressed: onContinue,
          ),
          TextButton(
            onPressed: onBack,
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
