import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedTextField extends StatelessWidget {
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
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onIconTap;
  const RoundedTextField({
    super.key,
    required this.title,
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
    this.controller,
    this.validator,
    this.onChanged,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor ?? Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border:
                borderColor != null
                    ? Border.all(color: borderColor!, width: 1.25.w)
                    : null,
          ),
          child: TextFormField(
            style: TextStyle(color: textColor),
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            keyboardType: keyboardType,
            obscureText: obscureText ?? false,
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 16.w,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: hintColor,
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
              ),
              suffixIcon:
                  icon != null
                      ? GestureDetector(
                        onTap: onIconTap,
                        child: Icon(icon, color: iconColor),
                      )
                      : null,
              errorStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
