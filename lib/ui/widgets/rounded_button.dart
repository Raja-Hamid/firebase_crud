import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final String? icon;
  final VoidCallback onPressed;
  const RoundedButton({
    super.key,
    required this.title,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(345.w, 60.h),
        backgroundColor: backgroundColor ?? Colors.transparent,
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: 1.25.w)
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            SvgPicture.asset(icon!, width: 18.w, height: 18.h),
            SizedBox(width: 10.w),
          ],
          Text(
            title,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
