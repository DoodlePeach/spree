import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';


class categories_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _categories_screen();
  }
}

class _categories_screen extends State<categories_screen> {

  Stream<QuerySnapshot> stream;
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
    Firestore.instance.collection('categories');
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
          title: Text(languages.skeleton_language_objects[config.app_language]['title_store_category'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),),
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
                    _categories_tile(context, snapshot.data.documents[index], index),
              );
            })
    );
  }

  //category list item
  Widget _categories_tile(context, document, index) {
    return ListTile(
      key: ValueKey(document.documentID),
      title: Text(document['categoryTitle'],
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text(document['categoryShortCode'],
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      leading: new ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Image.network(
          "${document['categoryCover'].length == 0 ? "" : document['categoryCover'][0]['publicUrl']}",
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

