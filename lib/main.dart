import 'package:flutter/material.dart' as mtr;
import 'package:spree/Layouts/Views/dashboard_screen.dart';
import 'package:spree/Layouts/Views/forgot_screen.dart';
import 'package:spree/Layouts/Views/intro_screen.dart';
import 'package:spree/Layouts/Views/login_screen.dart';
import 'package:spree/Layouts/Views/signup_screen.dart';
import 'package:spree/Layouts/Views/splash_screen.dart';

import 'Layouts/Views/device_id_screen.dart';

//routes for widget builder
var routes = <String, mtr.WidgetBuilder>{
  "/dashboard": (mtr.BuildContext context) => dashboard_screen(),
  "/intro": (mtr.BuildContext context) => intro_screen(),
  "/login": (mtr.BuildContext context) => login_screen(),
  "/signup": (mtr.BuildContext context) => signup_screen(),
  "/forgot": (mtr.BuildContext context) => forgot_screen(),
  "/device": (mtr.BuildContext context) => device_id_screen(),
  "/splash": (mtr.BuildContext context) => splash_screen()
};

//change this to your desired app colors
void main() => mtr.runApp(new mtr.MaterialApp(
    theme: mtr.ThemeData(
        primaryColor: mtr.Colors.deepPurple, accentColor: mtr.Colors.pink),
    debugShowCheckedModeBanner: false,
    home: splash_screen(),
    routes: routes));
