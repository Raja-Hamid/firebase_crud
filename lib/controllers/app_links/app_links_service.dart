import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_crud/controllers/routes/app_routes.dart';

class AppLinksService {
  static final AppLinks _appLinks = AppLinks();

  static Future<void> initAppLinks() async {
    final uri = await _appLinks.getInitialLink();
    _handleAppLink(uri);

    _appLinks.uriLinkStream.listen((Uri? uri) {
      _handleAppLink(uri);
    });
  }

  static void _handleAppLink(Uri? uri) async {
    if (uri != null) {
      final allParams = uri.queryParameters;
      final mode = allParams['mode'];
      final oobCode = allParams['oobCode'];

      if (mode == 'resetPassword' && oobCode?.isNotEmpty == true) {
        try {
          await FirebaseAuth.instance.verifyPasswordResetCode(oobCode!);
          Get.toNamed(AppRoutes.newPasswordScreen, arguments: oobCode);
        } on FirebaseAuthException catch (e) {
          Get.snackbar(
            'Invalid Link',
            e.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }

      if (mode == 'verifyEmail' && oobCode?.isNotEmpty == true) {
        try {
          await FirebaseAuth.instance.checkActionCode(oobCode!);
          await FirebaseAuth.instance.applyActionCode(oobCode);

          final authController = Get.find<AuthController>();
          authController.markEmailAsVerified();

          Get.snackbar(
            'Email Verified',
            'Your email has been successfully verified!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } on FirebaseAuthException catch (e) {
          Get.snackbar(
            'Verification Failed',
            e.message ?? 'Invalid or expired link.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    }
  }
}
