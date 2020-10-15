import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/circular_percent_indicator.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';


class todos_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _todos_screen();
  }
}

class _todos_screen extends State<todos_screen> {

  Stream<QuerySnapshot> stream;
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference collectionReference =
    Firestore.instance.collection('todo');
    setState(() {
      stream = collectionReference.where("todoStaff", arrayContains: prefs.getString("staff_firestore_id")).limit(100).snapshots();
      loaded = true;
    });
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
          title: Text(languages.skeleton_language_objects[config.app_language]['todo_title'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),),
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
                    _todos_tile(context, snapshot.data.documents[index], index),
              );
            })
    );
  }

  //leaves list item
  Widget _todos_tile(context, document, index) {
    return ListTile(
      key: ValueKey(document.documentID),
      leading: CircularPercentIndicator(
        radius: 40.0,
        lineWidth: 3.0,
        percent: double.parse(document['todoRating'].toString())/ 100,
        center: new Text("${document['todoRating']}%", style: TextStyle(fontSize: 10),),
        progressColor: Colors.deepPurple,
      ),
      trailing: IconButton(
        onPressed: (){
          if(document['todoRating'] <= 100 && document['todoRating'] >= 1){
            func_update_todo(context, document);
          }
        },
        icon: Icon(Icons.edit, color: document['todoRating'] == 100 ? Colors.white : Colors.grey[400],),
      ),
      title: Text(document['todoTitle'],
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text("Status : " + document['todoStatus'],
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      onTap: () {
      },
    );
  }


    TextEditingController progressController = new TextEditingController();
  func_update_todo(context, data) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
        ['update_todo_status']),
        content: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Text(languages.skeleton_language_objects[config.app_language]
              ['enter_the_curent_progress_value']),
              SizedBox(height: 10,),
                TextField(
                maxLines: 1,
                controller: progressController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText:
                        languages.skeleton_language_objects[config.app_language]
                            ['enter_progress_value'],
                    hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText:
                        languages.skeleton_language_objects[config.app_language]
                            ['enter_progress_value'],
                    labelStyle:
                        TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
              ),

            ],
          ),
        ),
        actions: [
          new FlatButton(
            child: Text(languages.skeleton_language_objects[config.app_language]
            ['cancel']),
            onPressed: () => Navigator.pop(context),
          ),
          new FlatButton(
            child: Text(
              languages.skeleton_language_objects[config.app_language]
              ['complete'],
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              if(int.parse(progressController.text) <= 100 && int.parse(progressController.text) >= 1 ){
                update_attendance(data);
                Navigator.pop(context);
              } else {
                config.func_do_toast(languages.skeleton_language_objects[config.app_language]
                ['progress_value_can_be_1_to_100'], Colors.red);
              }

            },
          ),
        ],
      ),
    );
  }


  update_attendance(data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var values = {
      "todoRating" : int.parse(progressController.text),
      "updatedAt" : FieldValue.serverTimestamp(),
      "todoStatus" : int.parse(progressController.text) == 100 ? "Done" : data["todoStatus"],
      "updatedBy" : prefs.getString("staff_firestore_id")
    };
    await config.update_a_record("todo", values, data["id"]);
    config.func_do_toast("Progress Status Updated", Colors.green);
    setState(() {
      progressController.clear();
      loaded = false;
      get_data();
    });
  }

}

