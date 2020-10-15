import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/intro_screen_contents.dart';
import 'package:spree/Utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/languages.dart';

class signup_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _signup_screen();
  }
}

class _signup_screen extends State<signup_screen>
    with SingleTickerProviderStateMixin {
  //fireabase init
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  var user_data;

  //email and password controller
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: signupBody(context),
      ),
    );
  }

  signupBody(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[signupHeader(), signupFields(context)],
        ),
      );

  signupHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'assets/images/app_logo.png',
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            languages.skeleton_language_objects[config.app_language]['Spree_welcomes_you'],
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
            languages.skeleton_language_objects[config.app_language]['signin_to_manage_youre_store'],
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontFamily: "Roboto"),
          ),
        ],
      );

  signupFields(BuildContext context) => Container(
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

//            keyboardType: ,
                decoration: InputDecoration(
                    hintText: languages.skeleton_language_objects[config.app_language]['enter_your_email_address'],
                    hintStyle:
                        TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText: languages.skeleton_language_objects[config.app_language]['email'],
                    labelStyle: TextStyle(
                        fontSize: 12.0, fontFamily: "Roboto")),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: languages.skeleton_language_objects[config.app_language]['enter_your_password'],
                    hintStyle:
                        TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText: languages.skeleton_language_objects[config.app_language]['password'],
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
              child: FlatButton(
                child: Text(
                  languages.skeleton_language_objects[config.app_language]['signup'],
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                color: Colors.deepOrange,
                onPressed: () {
                  if (passwordController.text.length > 4 &&
                      emailController.text.length > 4) {
                    Fluttertoast.showToast(
                        msg: languages.skeleton_language_objects[config.app_language]['creating_your_account'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                        verify_email_on_db(emailController.text, passwordController.text, context);
                  } else {
                    Fluttertoast.showToast(
                        msg: languages.skeleton_language_objects[config.app_language]['enter_all_Fields'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
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
                  style: TextStyle(color: Colors.deepPurple, fontSize: 12.0),
                ),
                color: Colors.white,
                onPressed: () {
                  navigation.goToLogin(context);
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            GestureDetector(
              child: Text(
                languages.skeleton_language_objects[config.app_language]['terms_and_condition'],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontFamily: "Roboto"),
              ),
              onTap: () {
                _launchURL();
              },
            )
          ],
        ),
      );

  //signup func
  Future<String> signUp(String email, String password, context) async {
    final FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password
    )).user;

    if (user != null) {
      update_user_data(user.uid.toString(), email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_state", "auth_user");
      await prefs.setString("user_id", user.uid);
      await prefs.setString("email", user.email);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_state", "guest_user");
    }
    return user.uid;
  }

  verify_email_on_db(String email, String password, context) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('user')
        .where("email", isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length > 1){
      config.func_do_toast("Email used more than one record", Colors.red);
    } else if(documents.length == 1){
      user_data = documents[0];
      signUp(email, password, context);
    } else {
      config.func_do_toast("Email not registered on our database", Colors.red);
    }
  }

  update_user_data(uid, email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_firestore_id", uid);
    var values = {"authenticationUid" : uid.toString()};
    await config.update_a_record("user", values,  user_data["id"]);
    await get_user_info(uid, email);
  }

  //launch terms page
  _launchURL() async {
  }

  //get the loggedin user info
  get_user_info(user_id, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('user')
        .where("email", isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length == 1){
      prefs.setString("user_authenticationUid", documents[0]["authenticationUid"]);
      prefs.setString("user_CreatedAt", documents[0]["createdAt"].toString());
      prefs.setString("user_email", documents[0]["email"]);
      prefs.setString("user_phoneNumber", documents[0]["phoneNumber"]);
      prefs.setString("user_firstName", documents[0]["firstName"]);
      prefs.setString("user_roles", documents[0]["roles"].toString());
      prefs.setString("user_firstName", documents[0]["firstName"]);
      prefs.setString("user_lastName", documents[0]["lastName"]);
      prefs.setString("user_fullName", documents[0]["fullName"]);
      config.permisiions = documents[0]["roles"].toString();
      manage_device_session(documents[0]["id"]);
    }
    else if (documents.length > 1) {
      config.func_do_toast("This user has multiple accounts", Colors.red);
    } else {
      config.func_do_toast("User email not assigned to any account on system", Colors.red);
    }
  }

  //manage a device session
  manage_device_session(String user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('deviceSessions')
        .where("sessionDevice", isEqualTo: prefs.getString("device_firestore_id"))
        .where("sessionLogoutDate", isEqualTo: null)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length >= 1){
      update_device_sessions(user_id, documents);
    } else {
      create_device_sessions(user_id);
    }
  }


  //logout all other sessions associated with this device
  void update_device_sessions(user_id, documents) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int x = 0; x < documents.length; x++){
      var data = {
        "updatedAt" : FieldValue.serverTimestamp(),
        "updatedBy" : prefs.getString("user_firestore_id"),
        "sessionLogoutDate" : FieldValue.serverTimestamp()
      };
      Firestore.instance.collection('deviceSessions').document(documents[x]["id"]).updateData(data);
      (x + 1) == documents.length ? create_device_sessions(user_id) : "";
    }
  }

  //create a session with this device
  void create_device_sessions(user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var session_id = DateTime.now().millisecondsSinceEpoch.toString();
    var data = {
      "createdAt" : FieldValue.serverTimestamp(),
      "createdBy" : user_id,
      "id" : session_id,
      "importHash" : null,
      "sessionDevice" : prefs.getString("device_firestore_id"),
      "sessionDeviceType" : "POS",
      "sessionIp" : "123QWE",
      "sessionLoginDate" : FieldValue.serverTimestamp(),
      "sessionLogoutDate" : null,
      "sessionNetwork" : "123qwe",
      "sessionUser" : user_id,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : user_id,
    };
    Firestore.instance.collection('deviceSessions').document(session_id).setData(data);
    prefs.setString("deviceSessions_firestore_id", data["id"]);
    prefs.setString("deviceSessions_createdAt", data["createdAt"].toString());
    prefs.setString("deviceSessions_sessionDeviceType", data["sessionDeviceType"]);
    prefs.setString("deviceSessions_sessionIp", data["sessionIp"]);
    prefs.setString("deviceSessions_sessionLoginDate", data["sessionLoginDate"].toString());
    prefs.setString("deviceSessions_sessionNetwork", data["sessionNetwork"]);
    navigation.goToDashboard(context);
  }

}
