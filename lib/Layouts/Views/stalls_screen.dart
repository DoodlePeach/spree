import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class stalls_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _stalls_screenState();
  }
}

class _stalls_screenState extends State<stalls_screen> {

  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(languages.skeleton_language_objects[config.app_language]['store_outlets'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),),
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
                  _stalls_tile(context, snapshot.data.documents[index], index),
            );
          })
    );
  }

  //get stalls data
  get_data() {
    CollectionReference collectionReference =
    Firestore.instance.collection('stall');
    stream = collectionReference.limit(100).snapshots();
  }


  @override
  void initState() {
    super.initState();
    get_data();
  }

  //stall list items
  Widget _stalls_tile(context, document, index) {
    return ListTile(
      key: ValueKey(document.documentID),
      title: Text(document['stallName'].toString().toUpperCase(),
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text( "${languages.skeleton_language_objects[config.app_language]['stall_is']} : " + document['stallIsStatus'],
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      trailing: Icon(document["stallStatus"] == "active" ? Icons.check_circle : Icons.remove_circle_outline, color: Colors.green[800], size: 20),
    leading: new ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Image.network(
          "${document['stallCover'].length == 0 ? "" : document['stallCover'][0]['publicUrl']}",
          height: 60,
          width: 60,
          fit: BoxFit.fill,
        ),
      ),
      onTap: () {
      },
    );
  }

}

