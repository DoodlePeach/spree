import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Layouts/Views/staff_details_screen.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';

class staff_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _staff_screenState();
  }
}

class _staff_screenState extends State<staff_screen> {
  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
        Firestore.instance.collection('staff');
    stream = collectionReference.limit(100).snapshots();
  }

  @override
  void initState() {
    super.initState();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          elevation: 3,
          title: Text(
            languages.skeleton_language_objects[config.app_language]
                ['stall_staffs'],
            style: TextStyle(
                fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),
          ),
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
                itemBuilder: (context, index) => _staffs_tile(
                    context, snapshot.data.documents[index], index),
              );
            }));
  }

  //staff list item
  Widget _staffs_tile(context, document, index) {
      return ListTile(
        dense: true,
        selected: true,
        key: ValueKey(document.documentID),
        title: Text(document['staffNames'].toString().toUpperCase(),
            maxLines: 1,
            style: new TextStyle(
                fontFamily: "Roboto", fontSize: 14, color: Colors.grey[800])),
        subtitle: Text("ID : " + document['staffIdentityCard'],
            maxLines: 2,
            style: new TextStyle(
                fontFamily: "Roboto", fontSize: 12, color: Colors.grey[500])),
        trailing: Icon(Icons.keyboard_arrow_right),
        leading: new CircleAvatar(
            radius: 22.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(
                "${document['staffProfile'].length == 0 ? "" : document['staffProfile'][0]['publicUrl']}",)),
        onTap: () {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new staff_details_screen(document['id']),
          );
          Navigator.of(context).push(route);
        },
      );
  }
}
