import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

import 'inventory_details_screen.dart';



class inventory_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _inventory_screenState();
  }
}

class _inventory_screenState extends State<inventory_screen> {

  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
    Firestore.instance.collection('products');
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
          title: Text(languages.skeleton_language_objects[config.app_language]['stall_inventory'], style: TextStyle(fontFamily: "Roboto", fontSize: 17, color: Colors.grey[800]),),
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
                    _inventory_tile(context, snapshot.data.documents[index], index),
              );
            })
    );
  }

  //inventory list item
  Widget _inventory_tile(context, document, index) {
    return ListTile(
      key: ValueKey(document.documentID),
      title: Text(document['productName'].toUpperCase(),
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      subtitle: Text(languages.skeleton_language_objects[config.app_language]['sku'] + " : " + document['productSku'].toString(),
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      trailing: Icon(Icons.arrow_forward, size: 20,),
      leading: new ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Image.network(
          document['productImage'][0]['publicUrl'],
          height: 60,
          width: 60,
          fit: BoxFit.fill,
        ),
      ),
      onTap: () {

        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new inventory_details_screen(document),
        );
        Navigator.of(context).push(route);

      },
    );
  }

}

