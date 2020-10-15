import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';


class product_sale_history extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _product_sale_historyState();
  }
}

class _product_sale_historyState extends State<product_sale_history> {

  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
    Firestore.instance.collection('units');
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
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.grey[100],
          elevation: 2,
          title: Text(languages.skeleton_language_objects[config.app_language]['product_sale_history'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),),
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
                  _sale_history_tile(context, snapshot.data.documents[index], index),
            );
          })
    );
  }

  //sale history list item
  Widget _sale_history_tile(context, document, index) {
    return ListTile(
      key: ValueKey(document.documentID),
      leading:Container(
        width: 30,
        child:  Center(
          child: Icon(FontAwesomeIcons.pallet),
        ),
      ),
      title: Text(document['unitsName'],
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text( "Units State : " + document['unitsCode'],
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      trailing: Text(document['unitsAllowDecimal'],
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 11, color: Colors.purpleAccent)),
      onTap: () {
      },
    );
  }

}

