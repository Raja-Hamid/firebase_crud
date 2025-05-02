import 'package:firebase_crud/ui/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crud/constants/colors.dart';

class DatePickerTextField extends StatelessWidget {
  final String title;
  final String? hintText;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? iconColor;
  final TextInputType? keyboardType;
  final IconData? icon;
  final EdgeInsets? margin;
  final bool? obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const DatePickerTextField({
    super.key,
    required this.title,
    required this.controller,
    this.hintText,
    this.backgroundColor,
    this.titleColor,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.keyboardType,
    this.icon,
    this.iconColor,
    this.margin,
    this.obscureText,
    this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: AppColors.backgroundColor,
              surface: AppColors.backgroundColor,
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.black),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day} ${_getMonthName(pickedDate.month)}, ${pickedDate.year}";
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: RoundedTextField(
          title: title,
          hintText: hintText,
          titleColor: titleColor,
          textColor: textColor,
          hintColor: hintColor,
          borderColor: borderColor,
          icon: icon,
          controller: controller,
          validator: validator,
        ),
      ),
    );
  }
}
