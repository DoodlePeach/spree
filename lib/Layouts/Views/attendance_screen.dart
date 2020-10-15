import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/random_string.dart';

class attendance_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _attendance_screenState();
  }
}

class _attendance_screenState extends State<attendance_screen> {
  Stream<QuerySnapshot> stream;
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String staff_id = prefs.getString("staff_firestore_id");
    CollectionReference collectionReference =
        Firestore.instance.collection('attendance');
    setState(() {
      stream = collectionReference
          .where("attendanceStaff", isEqualTo: staff_id)
          .limit(100)
          .snapshots();
      config.func_do_toast("Loading Complete", Colors.grey);
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(
            languages.skeleton_language_objects[config.app_language]
                ['attendance_title'],
            style: TextStyle(
                fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, size: 24, color: Colors.grey[800]),
              onPressed: () {
                setState(() {
                  get_data();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add, size: 24, color: Colors.grey[800]),
              onPressed: () {
                var permission =  config.check_permissions("attendanceEditor");
                if(permission["can"] == true){
                  func_create_chec_in(context);
                } else {
                  config.func_do_toast(permission["message"], Colors.purple);
                }
              },
            ),
          ],
        ),
        body: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: SpinKitChasingDots(color: Colors.deepPurple),
                );
              count = snapshot.data.documents.length;
              return new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _attendance_tile(
                    context, snapshot.data.documents[index], index),
              );
            }));
  }

  //attendance list item
  Widget _attendance_tile(context, document, index) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Card(
        elevation: 2,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Text(config.get_stall_by_ids(document['expenseStall']),
                maxLines: 2,
                textAlign: TextAlign.left,
                style: new TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 14,
                    color: Colors.deepOrange)),
            Text(document['attendanceRef'].toString(),
                maxLines: 2,
                style: new TextStyle(fontFamily: "Roboto", fontSize: 11)),
            Container(
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListTile(
                        dense: true,
                        enabled: true,
                        leading: Icon(
                          Icons.hourglass_empty,
                          color: Colors.deepOrange,
                        ),
                        title: Text("Clock in",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.purple[700])),
                        subtitle: Text(document['attendanceClockIn'],
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.purple[300]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(
                        Icons.hourglass_full,
                        color: Colors.green,
                      ),
                      title: Text("Clock out",
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[700])),
                      subtitle: Text(
                          document['attendanceClockOut'] == null
                              ? "Click to Checkout"
                              : document['attendanceClockOut'],
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: document['attendanceClockOut'] == null
                                  ? Colors.red[800]
                                  : Colors.purple[300])),
                      onTap: () {
                        var permission =  config.check_permissions("attendanceEditor");
                        if(permission["can"] == true){
                          func_update_chec_out(context, document);
                        } else {
                          config.func_do_toast(permission["message"], Colors.purple);
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Create an attendance
  func_create_chec_in(context) {
    DateTime now = new DateTime.now();
    DateTime date =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
            ['create_adjust']),
        content: Text(languages.skeleton_language_objects[config.app_language]
            ['confirm_create_adjust']),
        actions: [
          new FlatButton(
            child: Text(languages.skeleton_language_objects[config.app_language]
                ['cancel']),
            onPressed: () => Navigator.pop(context),
          ),
          new FlatButton(
            child: Text(
              languages.skeleton_language_objects[config.app_language]
                  ['complete'],
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              create_a_new_attendance(date.toString());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //check out of a current attendance
  func_update_chec_out(context, data) {
    DateTime now = new DateTime.now();
    DateTime date =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
            ['update_attendance']),
        content: Text(languages.skeleton_language_objects[config.app_language]
                ['enter_your_clock_out_time'] +
            "\n\n${date.toString()}"),
        actions: [
          new FlatButton(
            child: Text(languages.skeleton_language_objects[config.app_language]
                ['cancel']),
            onPressed: () => Navigator.pop(context),
          ),
          new FlatButton(
            child: Text(
              languages.skeleton_language_objects[config.app_language]
                  ['complete'],
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              update_attendance(date.toString(), data);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //update checkout on firebase
  update_attendance(date, data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var values = {
      "attendanceClockOut": date,
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("staff_firestore_id")
    };
    await config.update_a_record("attendance", values, data["id"]);
    config.func_do_toast("Check-out Successfull", Colors.green);
    setState(() {
      loaded = false;
      get_data();
    });
  }

  //create attendance on firebase
  create_a_new_attendance(date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var attendance_id = randomAlphaNumeric(20);
    var values = {
      "attendanceClockIn": date,
      "attendanceClockOut": null,
      "attendanceNote": null,
      "attendanceRef":
          "${date.toString().substring(0, 4) + attendance_id.toString().substring(0, 4)}",
      "attendanceStaff": prefs.getString("staff_firestore_id"),
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": prefs.getString("user_firestore_id"),
      "expenseStall": [prefs.getString("stall_firestore_id")],
      "id": attendance_id.toString(),
      "importHash": null,
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.create_a_record("attendance", values, attendance_id);
    config.func_do_toast("Check in created", Colors.green);
    setState(() {
      loaded = false;
      get_data();
    });
  }
}
