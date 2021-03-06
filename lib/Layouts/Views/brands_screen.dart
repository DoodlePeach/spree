import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';



class brands_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _brands_screenState();
  }
}

class _brands_screenState extends State<brands_screen> {

  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
    Firestore.instance.collection('brands');
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
            color: Colors.grey[800],
          ),
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(languages.skeleton_language_objects[config.app_language]['title_store_brands'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),),
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
                    _brands_tile(context, snapshot.data.documents[index], index),
              );
            })
    );
  }

  //Brands list item
  Widget _brands_tile(context, document, index) {
    return ListTile(
      key: ValueKey(document.documentID),
      title: Text(document['brandTitle'].toString().toUpperCase(),
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14, color: Colors.grey[800])),
      subtitle: Text( document['brandDetails'],
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 10, color: Colors.grey[600])),
      leading: new ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Image.network(
          "${document['brandCover'] == 0 ? "" : document['brandCover'][0]['publicUrl']}",
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        ),
      ),
      onTap: () {
      },
    );
  }

}

