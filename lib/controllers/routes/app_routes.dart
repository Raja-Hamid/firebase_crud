import 'package:firebase_crud/ui/screens/home_screen.dart';
import 'package:firebase_crud/ui/screens/new_password_screen.dart';
import 'package:firebase_crud/ui/screens/sign_up_with_email_screens.dart';
import 'package:firebase_crud/ui/screens/sign_up_with_phone_number_screens.dart';
import 'package:firebase_crud/ui/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_crud/ui/screens/reset_password_screen.dart';
import 'package:firebase_crud/ui/screens/sign_in_screen.dart';
import 'package:firebase_crud/ui/screens/sign_up_screen.dart';
import 'package:firebase_crud/ui/screens/welcome_screen.dart';

class AppRoutes {
  static const splashScreen = '/splashScreen';
  static const welcomeScreen = '/welcomeScreen';
  static const signInScreen = '/signInScreen';
  static const signUpScreen = '/signUpScreen';
  static const resetPasswordScreen = '/resetPasswordScreen';
  static const newPasswordScreen = '/newPasswordScreen';
  static const signUpWithEmailScreens = '/signUpWithEmailScreens';
  static const signUpWithPhoneNumberScreens = '/signUpWithPhoneNumberScreens';
  static const homeScreen = '/homeScreen';

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<dynamic>(name: splashScreen, page: () => const SplashScreen()),
    GetPage<dynamic>(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage<dynamic>(name: signInScreen, page: () => const SignInScreen()),
    GetPage<dynamic>(
      name: resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage<dynamic>(
      name: newPasswordScreen,
      page: () {
        final String oobCode = Get.arguments as String;
        return NewPasswordScreen(oobCode: oobCode);
      },
    ),
    GetPage<dynamic>(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage<dynamic>(
      name: signUpWithEmailScreens,
      page: () => const SignUpWithEmailScreens(),
    ),
    GetPage<dynamic>(
      name: signUpWithPhoneNumberScreens,
      page: () => const SignUpWithPhoneNumberScreens(),
    ),
    GetPage<dynamic>(name: homeScreen, page: () => const HomeScreen()),
  ];
}
