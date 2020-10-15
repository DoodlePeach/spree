import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';


class notice_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _notice_screenState();
  }
}

class _notice_screenState extends State<notice_screen> {

  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
    Firestore.instance.collection('notice');
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
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(languages.skeleton_language_objects[config.app_language]['store_notice'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700]),),
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
                    _notice_tile(context, snapshot.data.documents[index], index),
              );
            })
    );
  }

  Widget _notice_tile(context, document, index) {
    return ListTile(
        isThreeLine: true,
      key: ValueKey(document.documentID),
      title: Text(document['noticeTitle'],
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text(document['noticeDetails'],
          maxLines: 5,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12, color: Colors.grey[600])),
      onTap: () {
      },
    );
  }

}

