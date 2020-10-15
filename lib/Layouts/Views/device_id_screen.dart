import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Layouts/Views/splash_screen.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/navigation.dart';
import 'package:spree/Utils/config.dart';


class device_id_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _device_id_screen();
  }
}

class _device_id_screen extends State<device_id_screen>
    with SingleTickerProviderStateMixin {

  //device field controller
  TextEditingController deviceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: forgotBody(context),
      ),
    );
  }

  forgotBody(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[forgotHeader(), forgotFields(context)],
        ),
      );

  forgotHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //app logo
          Image.asset(
            'assets/images/app_logo.png',
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            languages.skeleton_language_objects[config.app_language]['device_serial_setup'],
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                color: Colors.purple,
                fontFamily: "Roboto"),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            languages.skeleton_language_objects[config.app_language]['device_serial_setup_reason'],
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontFamily: "Roboto"),
          ),
        ],
      );

  forgotFields(BuildContext context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                controller: deviceController,
                keyboardType: TextInputType.text,
                maxLength: 30,
                decoration: InputDecoration(
                    hintText: languages.skeleton_language_objects[config.app_language]['device_serial_id'],
                    hintStyle:
                        TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText: languages.skeleton_language_objects[config.app_language]['device_serial_id'],
                    labelStyle: TextStyle(
                        fontSize: 12.0, fontFamily: "Roboto")),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: MaterialButton(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  languages.skeleton_language_objects[config.app_language]['save'],
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepPurple,
                minWidth: 150,
                onPressed: () {
                  update_device();
                },
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: FlatButton(
                child: Text(
                  languages.skeleton_language_objects[config.app_language]['restart_app'],
                  style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
                ),
                color: Colors.white,
                onPressed: () {
                  Timer(Duration(seconds: 3), () => navigation.goToIntro(context));
                  },
              ),
            ),
          ],
        ),
      );

  void update_device() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("device_deviceSerial", deviceController.text);
    await prefs.setString("user_state", "guest_user");
    config.func_do_toast(languages.skeleton_language_objects[config.app_language]['restart_app'], Colors.green);
  }

}
