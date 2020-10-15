import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';


class leaves_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _leaves_screen();
  }
}

class _leaves_screen extends State<leaves_screen> {

  Stream<QuerySnapshot> stream;
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference collectionReference =
    Firestore.instance.collection('leave');
    setState(() {
      stream = collectionReference.where("leaveUserId", isEqualTo: prefs.getString("user_firestore_id")).limit(100).snapshots();
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
          title: Text(languages.skeleton_language_objects[config.app_language]['leave_title'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),),
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
                itemBuilder: (context, index) =>
                    _leaves_tile(context, snapshot.data.documents[index], index),
              );
            })
    );
  }

  //leaves list item
  Widget _leaves_tile(context, document, index) {
    return Container(
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(document['leaveRef'].toString(),
                  maxLines: 1,
                  style: new TextStyle(fontFamily: "Roboto", fontSize: 14, color: Colors.deepPurple)),
              Divider(height: 15,),
              Text(document['leaveNote'].toString(),
                  maxLines: 4,
                  style: new TextStyle(fontFamily: "Roboto", fontSize: 12, color: Colors.grey[400])),
              Divider(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text("Start Date \n" + document['leaveStartDate'].toString(),
                        maxLines: 2,
                        style: new TextStyle(fontFamily: "Roboto", fontSize: 12, color: Colors.deepOrange)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("End Date \n" + document['leaveEndDate'].toString(),
                        maxLines: 2,
                        style: new TextStyle(fontFamily: "Roboto", fontSize: 12, color: Colors.deepOrange)),
                  ),
                ],
              ),
              Divider(height: 15,),
              Text("Assigned Staff Duties : " + config.get_staff_by_id(document['leaveAssignedStaff']).toString(),
                  maxLines: 1,
                  style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

}

