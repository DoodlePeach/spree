import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/navigation.dart';
import 'package:spree/Utils/config.dart';


class forgot_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _forgot_screen();
  }
}

class _forgot_screen extends State<forgot_screen>
    with SingleTickerProviderStateMixin {
  //firebase init
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //email field controller
  TextEditingController emailController = new TextEditingController();

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
            languages.skeleton_language_objects[config.app_language]['forgot_password'],
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
            languages.skeleton_language_objects[config.app_language]['you_will_receive_an_email_confirming_your_new_password'],
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                maxLength: 30,
                decoration: InputDecoration(
                    hintText: languages.skeleton_language_objects[config.app_language]['enter_your_email_adress'],
                    hintStyle:
                        TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText: languages.skeleton_language_objects[config.app_language]['email'],
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
                  languages.skeleton_language_objects[config.app_language]['send'],
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepPurple,
                minWidth: 150,
                onPressed: () {
                  sendPasswordResetEmail(emailController.text);
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
                  languages.skeleton_language_objects[config.app_language]['back_to_login'],
                  style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
                ),
                color: Colors.white,
                onPressed: () {
                  navigation.goToLogin(context);
                },
              ),
            ),
          ],
        ),
      );

  //func to send reset email
  Future<void> sendPasswordResetEmail(String email) async {
    Fluttertoast.showToast(
        msg: languages.skeleton_language_objects[config.app_language]['password_link_sent'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
