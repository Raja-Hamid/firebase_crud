import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/controllers/page_controllers/page_navigation_controller.dart';
import 'package:firebase_crud/controllers/routes/app_routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class AuthController extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationID;
  String? get verificationID => _verificationID;

  final RxBool isEmailVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.userChanges());
  }

  void markEmailAsVerified() {
    isEmailVerified.value = true;
  }

  void resetEmailVerification() {
    isEmailVerified.value = false;
  }

  void showLoadingDialog() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void hideLoadingDialog() => Get.back();

  // CHECK USER AUTHENTICATION STATUS
  bool get isAuthenticated => user != null;

  // SIGN UP WITH EMAIL
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String email,
    required String password,
    File? profilePicture,
  }) async {
    try {
      showLoadingDialog();

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;
      String? imageURL;
      if (profilePicture != null) {
        String fileName = 'profile_pictures/$uid.jpg';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(fileName)
            .putFile(profilePicture);

        TaskSnapshot snapshot = await uploadTask;
        imageURL = await snapshot.ref.getDownloadURL();
      }

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'dateOfBirth': dateOfBirth,
        if (imageURL != null) 'profilePicture': imageURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
      hideLoadingDialog();
      Get.snackbar(
        'Sign Up Successful!',
        'You have Successfully Registered.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        mainButton: TextButton(
          onPressed: () {},
          child: const Text('Okay', style: TextStyle(color: Colors.white)),
        ),
      );
      Get.toNamed(AppRoutes.signInScreen);
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Sign Up Failed!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // SIGN UP WITH PHONE NUMBER
  Future<void> sendPhoneOTP({required String phoneNumber}) async {
    try {
      showLoadingDialog();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.back();
        },
        verificationFailed: (FirebaseAuthException e) {
          hideLoadingDialog();
          Get.snackbar(
            'Process Failed!',
            e.message ?? 'Something went wrong.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        codeSent: (String verificationID, int? resendToken) {
          _verificationID = verificationID;
          hideLoadingDialog();
          Get.snackbar(
            'OTP Sent!',
            'A verification code has been sent to $phoneNumber.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.find<PageNavigationController>().nextPage();
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verificationID = verificationID;
        },
      );
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'OTP Not Sent!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> verifyOTP(String otpCode) async {
    try {
      showLoadingDialog();
      if (_verificationID == null) {
        throw Exception('Verification ID is null. Cannot verify OTP.');
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationID!,
        smsCode: otpCode,
      );
      await _auth.signInWithCredential(credential);
      hideLoadingDialog();
      Get.find<PageNavigationController>().nextPage();
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'OTP Verification Failed!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> finishPhoneSignUp({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String password,
  }) async {
    try {
      showLoadingDialog();
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not signed in');
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        hideLoadingDialog();
        Get.snackbar(
          'User Already Exists',
          'This phone number is already linked to another account.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      await user.updatePassword(password);
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': user.phoneNumber,
        'dateOfBirth': dateOfBirth,
        'createdAt': FieldValue.serverTimestamp(),
      });
      hideLoadingDialog();
      Get.snackbar(
        'Sign Up Successful',
        'Your account has been created!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Sign Up Failed!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // SIGN IN
  Future<void> signIn({required email, required password}) async {
    try {
      showLoadingDialog();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      hideLoadingDialog();
      Get.snackbar(
        'Sign In Successful!',
        'You have Successfully Signed In.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(AppRoutes.homeScreen);
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Sign in Failed!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.snackbar(
        'Signed Out',
        'Signed out Successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthErrors(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword({required String email}) async {
    try {
      showLoadingDialog();
      await _auth.sendPasswordResetEmail(email: email);
      hideLoadingDialog();
      Get.snackbar(
        'Success',
        'A Reset Password link has been sent to $email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.toNamed(AppRoutes.signInScreen);
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // UPDATE PASSWORD
  Future<void> updatePassword({
    required String oobCode,
    required String password,
  }) async {
    try {
      showLoadingDialog();
      await FirebaseAuth.instance.verifyPasswordResetCode(oobCode);
      await FirebaseAuth.instance.confirmPasswordReset(
        code: oobCode,
        newPassword: password,
      );
      hideLoadingDialog();
      Get.snackbar(
        'Success',
        'Password updated successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.toNamed(AppRoutes.signInScreen);
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // VERIFY EMAIL
  Future<void> sendVerificationEmail({required String email}) async {
    try {
      showLoadingDialog();
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: 'temp_pass_for_verification',
          );
      await userCredential.user?.sendEmailVerification();
      hideLoadingDialog();
      Get.snackbar(
        'Verification Email Sent!',
        'A verification link has been sent to $email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      _handleAuthErrors(e);
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // CHECK EMAIL VERIFICATION STATUS
  Future<bool> checkEmailVerificationStatus() async {
    User? user = _auth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  // DELETE USER ACCOUNT
  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    await user?.reload();
    await user?.delete();
  }

  // FIREBASE AUTH ERRORS HANDLING
  void _handleAuthErrors(FirebaseAuthException e) {
    Get.snackbar(
      'Error',
      e.code,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
