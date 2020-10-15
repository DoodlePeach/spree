import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';
import 'customer_details_screen.dart';



class customers_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _customers_screenState();
  }
}

class _customers_screenState extends State<customers_screen> {

  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
    Firestore.instance.collection('customers');
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
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(languages.skeleton_language_objects[config.app_language]['title_store_customer'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),),
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
                    _customers_tile(context, snapshot.data.documents[index], index),
              );
            })
    );
  }

  //customer list item
  Widget _customers_tile(context, document, index) {
    print(document['customerAvatar'].toString());
    return ListTile(
      dense: true,
      key: ValueKey(document.documentID),
      title: Text(document['customerNames'].toString().toUpperCase(),
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text(document['customerEmail'],
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      trailing: Icon(Icons.keyboard_arrow_right),
      leading: new CircleAvatar(
        radius: 22,
          backgroundColor: Colors.grey[200],
          child:Image.network("${document['customerProfile'].length == 0 ? "" : document['customerProfile'][0]['publicUrl']}", fit: BoxFit.fill,)),
      onTap: () {

        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new customer_details_screen(document['id']),
        );
        Navigator.of(context).push(route);

      },
    );
  }

}

