import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/intro_screen_contents.dart';
import 'package:spree/Utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash_screen extends StatefulWidget {
  @override
  _splash_screenState createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    get_device();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/app_logo.png',
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        intro_screen_contents.name,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Roboto",
                          fontSize: 18.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(strokeWidth: 2),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      intro_screen_contents.store,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 11.0,
                          color: Colors.black38),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ));
  }

  //checks user state
  void get_user_state() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    config.permisiions = prefs.getString("user_roles");
    setState(() {
      String user_state = prefs.getString('user_state') == null ? "///" : prefs.getString('user_state');
      if (user_state == "///") {
        Timer(Duration(seconds: 3), () => navigation.goToIntro(context));
      } else if (user_state.contains("auth_user")) {
        get_user_info();
      } else if (user_state.contains("guest_user")) {
        Timer(Duration(seconds: 3), () => navigation.goToLogin(context));
      }
    });
  }

  //manage a device session
  void get_user_info() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("user_firestore_id") != null){
      get_user_staff();
    } else {
      final QuerySnapshot result = await Firestore.instance
          .collection('user')
          .where("authenticationUid", isEqualTo: prefs.getString("user_id"))
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 1) {
        prefs.setString("user_avartar", documents[0]["avatars"] == null ? "" : documents[0]["avatars"][0]["publicUrl"]);
        prefs.setString("user_firestore_id", documents[0]["authenticationUid"]);
        prefs.setString("user_CreatedAt", documents[0]["createdAt"].toString());
        prefs.setString("user_email", documents[0]["email"]);
        prefs.setString("user_phoneNumber", documents[0]["phoneNumber"]);
        prefs.setString("user_roles", documents[0]["roles"].toString());
        prefs.setString("user_firstName", documents[0]["firstName"]);
        prefs.setString("user_lastName", documents[0]["lastName"]);
        prefs.setString("user_fullName", documents[0]["fullName"]);
        prefs.setString("user_firestore_id", documents[0]["id"]);
        get_user_staff();
      }
    }
  }

  //manage a device session
  void get_user_staff() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("staff_createdAt") != null){
      get_device_session();
    } else {
      final QuerySnapshot result = await Firestore.instance
          .collection('staff')
          .where("staffUserId", isEqualTo: prefs.getString("user_firestore_id"))
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if (documents.length == 1) {
        prefs.setString("staff_avatar", documents[0]["staffProfile"] == null ? "" : documents[0]["staffProfile"][0]["publicUrl"]);
        prefs.setString("staff_firestore_id", documents[0]["id"]);
        prefs.setString("staff_staffAbout", documents[0]["staffAbout"]);
        prefs.setString("staff_staffCommision", documents[0]["staffCommision"].toString());
        prefs.setString("staff_phoneNumber", documents[0]["phoneNumber"]);
        prefs.setString("staff_staffIdentityCard", documents[0]["staffIdentityCard"]);
        prefs.setString("staff_staffIsAServiceWorker", documents[0]["staffIsAServiceWorker"]);
        prefs.setString("staff_staffPhoneNumber", documents[0]["staffPhoneNumber"]);
        prefs.setString("staff_staffUserId", documents[0]["staffUserId"]);
        prefs.setString("staff_createdAt", documents[0]["fullName"]);
        get_device_session();
      }
    }
  }

  //manage a device session
  void get_device_session() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("device_session_createdAt") != null){
      Timer(Duration(seconds: 3), () => navigation.goToDashboard(context));
    } else {
      final QuerySnapshot result = await Firestore.instance
          .collection('deviceSessions')
          .where("sessionDevice", isEqualTo: prefs.getString("device_firestore_id"))
          .where("sessionUser", isEqualTo: prefs.getString("user_firestore_id"))
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.isNotEmpty) {
        prefs.setString("device_session_createdAt", documents[0]["createdAt"].toString());
        prefs.setString("device_session_id", documents[0]["id"]);
        prefs.setString("device_session_sessionDevice", documents[0]["sessionDevice"]);
        prefs.setString("device_session_sessionDeviceType", documents[0]["sessionDeviceType"]);
        prefs.setString("device_session_sessionIp", documents[0]["sessionIp"]);
        prefs.setString("device_session_sessionNetwork", documents[0]["sessionNetwork"]);
        prefs.setString("device_session_sessionUser", documents[0]["sessionUser"]);
        Timer(Duration(seconds: 3), () => navigation.goToDashboard(context));
      }
    }
  }

  // get device info
  void get_device() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("device_deviceSerial") == null){
      config.func_do_toast("Device missing serial", Colors.red);
      Timer(Duration(seconds: 3), () => navigation.goInitializeDevice(context));
    } else {
      if(prefs.getString("device_createdAt") == null){
        final QuerySnapshot result = await Firestore.instance
            .collection('devices')
            .where("deviceSerial", isEqualTo: prefs.getString("device_deviceSerial"))
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length > 1) {
          config.func_do_toast(
              "Invalid Device or Device id has been initial more than once", Colors.red);
        } else if (documents.length == 1) {
          prefs.setString("device_firestore_id", documents[0]["id"]);
          prefs.setString("device_deviceName", documents[0]["deviceName"]);
          prefs.setString("device_deviceNote", documents[0]["deviceNote"]);
          prefs.setString("device_deviceStall", documents[0]["deviceStall"]);
          prefs.setString("device_deviceType", documents[0]["deviceType"]);
          prefs.setString("device_createdAt", documents[0]["createdAt"].toString());

          get_user_state();
        } else {
          config.func_do_toast("Device not initialised on web", Colors.red);
        }
      } else {
        get_user_state();
      }
    }
  }

}
