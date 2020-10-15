import 'package:flutter/material.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';

class memo_details_screen extends StatefulWidget {

  memo_details_screen(this.params);
  final params;

  @override
  _memo_details_screenState createState() => _memo_details_screenState(params);
}

class _memo_details_screenState extends State<memo_details_screen> {

  _memo_details_screenState(this.params);
  final params;

  @override
  void initState() {
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
          title: Text(languages.skeleton_language_objects[config.app_language]['memo_title'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[800]),),
        ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                params["memosCover"] == null ? "" : params["memosCover"][0]["publicUrl"],
                fit: BoxFit.fill,
              ),
            ),
            ListTile(
              title: Text(languages.skeleton_language_objects[config.app_language]['memo_title'], style: TextStyle(fontFamily: "Roboto", color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w700)),
              subtitle: Text('${params["memosTitle"].toUpperCase()}', style: TextStyle(fontFamily: "Roboto", color: Colors.grey[500], fontSize: 14)),
            ),
            ListTile(
              title: Text(languages.skeleton_language_objects[config.app_language]['memo_details'], style: TextStyle(fontFamily: "Roboto", color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w700)),
              subtitle: Text('${params["memosDetails"].toString().toUpperCase()}', style: TextStyle(fontFamily: "Roboto", color: Colors.grey[500], fontSize: 14)),
            ),

            ListTile(
              title: Text(languages.skeleton_language_objects[config.app_language]['memo_to'], style: TextStyle(fontFamily: "Roboto", color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w700)),
              subtitle: Text('${params["memosTo"].toString().toUpperCase()}', style: TextStyle(fontFamily: "Roboto", color: Colors.grey[500], fontSize: 14)),
            ),
            ListTile(
              title: Text(languages.skeleton_language_objects[config.app_language]['memo_start_date'], style: TextStyle(fontFamily: "Roboto", color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w700)),
              subtitle: Text('${params["memosStartDate"].toString().toUpperCase()}', style: TextStyle(fontFamily: "Roboto", color: Colors.grey[500], fontSize: 14)),
            ),
          ],
        ),
      )
    );
  }
}
