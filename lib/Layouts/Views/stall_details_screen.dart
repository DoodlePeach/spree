import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class stall_details_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _stall_details_screenState();
  }
}

class _stall_details_screenState extends State<stall_details_screen> {

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
  }

  String stallName = "", stallIsStatus = "", stallCover = "", stallType = "";

  void get_infors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("@@@ : " + stallCover.toString());
    setState(() {
      stallName = prefs.getString("stall_stallName");
      stallIsStatus = prefs.getString("stall_stallIsStatus");
      stallCover = prefs.getString("stall_stallCover");
      stallType = prefs.getString("stall_stallType");
    });
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
          title: Text(stallName, style: TextStyle(fontFamily: "Roboto", fontSize: 15, color: Colors.grey[800]),),
          actions: <Widget>[
            IconButton(
              onPressed: () {

              },
              icon: Icon(stallIsStatus == "active" ? Icons.check_circle : Icons.remove_circle_outline, color: Colors.green[800], size: 20),
            ),
          ],
        ),
      body: Column(
        children: <Widget>[
//          Container(
//            height: 250,
//            width: double.infinity,
//            child: Image.network(
//              stallCover,
//              fit: BoxFit.fill,
//            ),
//          ),
          ListTile(
            title: Text(languages.skeleton_language_objects[config.app_language]['store_online_status'], style: TextStyle(fontFamily: "Roboto", color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w700)),
            subtitle: Text('${stallType.toUpperCase()}', style: TextStyle(fontFamily: "Roboto", color: Colors.grey[500], fontSize: 14)),
          ),
          ListTile(
            title: Text(languages.skeleton_language_objects[config.app_language]['store_visibility'], style: TextStyle(fontFamily: "Roboto", color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w700)),
            subtitle: Text('${stallIsStatus.toString().toUpperCase()}', style: TextStyle(fontFamily: "Roboto", color: Colors.grey[500], fontSize: 14)),
          ),

        ],
      )
    );
  }
}
