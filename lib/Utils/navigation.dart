import 'package:flutter/material.dart';

class navigation {
  static void goToDashboard(BuildContext context) {
    Navigator.pushNamed(context, "/dashboard");
  }

  static void goToIntro(BuildContext context) {
    Navigator.pushNamed(context, "/intro");
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }

  static void goToSignup(BuildContext context) {
    Navigator.pushNamed(context, "/signup");
  }

  static void goChangePassword(BuildContext context) {
    Navigator.pushNamed(context, "/forgot");
  }

  static void goInitializeDevice(BuildContext context) {
    Navigator.pushNamed(context, "/device");
  }

  static void goSplash(BuildContext context) {
    Navigator.pushNamed(context, "/splash");
  }

}
