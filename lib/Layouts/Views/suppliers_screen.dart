import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Layouts/Views/supplier_details_screen.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';

class suppliers_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _suppliers_screenState();
  }
}

class _suppliers_screenState extends State<suppliers_screen> {
  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
        Firestore.instance.collection('suppliers');
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(
            languages.skeleton_language_objects[config.app_language]
                ['store_suppliers'],
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
                itemBuilder: (context, index) => _suppliers_tile(
                    context, snapshot.data.documents[index], index),
              );
            }));
  }

  //supplier list item
  Widget _suppliers_tile(context, document, index) {
    return ListTile(
      dense: true,
      key: ValueKey(document.documentID),
      title: Text(document['supplierBusinessName'].toString().toUpperCase(),
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text(
          "${languages.skeleton_language_objects[config.app_language]['supplier_name_is']} : " +
              document['supplierNames'],
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      trailing: Icon(Icons.keyboard_arrow_right),
      leading: new CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[200],
          child: Image.network(
            "${document['supplierProfile'].length == 0 ? "" : document['supplierProfile'][0]['publicUrl']}",
            fit: BoxFit.fill,
          )),
      onTap: () {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
              new supplier_details_screen(document['id']),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}
