import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';


class staff_details_screen extends StatefulWidget {

  staff_details_screen(this.staff_id);
  final staff_id;

  @override
  _staff_details_screenState createState() => _staff_details_screenState(staff_id);


}

class _staff_details_screenState extends State<staff_details_screen> {

  _staff_details_screenState(this.staff_id);
  final staff_id;

  @override
  void initState() {
    super.initState();
    get_staff_details();
  }

  Stream<QuerySnapshot> stream;
  var staff_documents;
  var staff_audit_documents;
  bool loaded = false;

  //check if product exist our db
  Future<bool> get_staff_details() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('staff')
        .where('id', isEqualTo: staff_id)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 1) {

      setState(() {
        staff_documents = documents;
        loaded = true;
        get_staff_audit_data();
      });

    }

    return documents.length == 1;
  }

  //get staff audit logs
  get_staff_audit_data() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('auditLogs')
        .where('createdById', isEqualTo: staff_documents[0]['staffUserId'])
        .limit(4)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      staff_audit_documents = documents;
    });
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
          title: Text( loaded == true ? staff_documents[0]['staffNames'] : languages.skeleton_language_objects[config.app_language]['loading_product_details'], style: TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800], fontWeight: FontWeight.w400),),
        ),
      body: loaded == true ? Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[

            Container(
              child: Column(
                children: <Widget>[

                  SizedBox(height: 20,),
                  CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                      NetworkImage("${staff_documents[0]['staffProfile'].length == 0 ? "" : staff_documents[0]['staffProfile'][0]['publicUrl']}",)),
                  SizedBox(height: 20,),
                  Text(staff_documents[0]['staffNames'],
                      maxLines: 2,
                      style: new TextStyle(fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800])),
                  SizedBox(height: 10,),
                  Text(staff_documents[0]['staffIdentityCard'],
                      maxLines: 2,
                      style: new TextStyle(fontFamily: "Roboto", fontSize: 12, color: Colors.grey[500])),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Container(height: 0.7, color: Colors.grey[400],),
            SizedBox(height: 10,),
            Container(height: 45, child: Row(
              children: <Widget>[

                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.message, color: Colors.grey[600], size: 24,),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.call, color: Colors.grey[600], size: 24,),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.alternate_email, color: Colors.grey[600], size: 24,),
                  ),
                ),
              ],
            ),),
            SizedBox(height: 20,),
            Text(languages.skeleton_language_objects[config.app_language]['staff_audit_logs'],
                maxLines: 2,
                style: new TextStyle(fontFamily: "Roboto", fontSize: 12, color: Colors.grey[800]), textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Container(
              height: 400,
              child: staff_audit_documents != null ?  ListView.builder(
                itemCount: staff_audit_documents.length,
                itemBuilder: (context, index) =>
                    _audit_tile(context, staff_audit_documents[index], index),
              ) :
              Center(
                child: SpinKitChasingDots(color: Colors.deepPurple),
              )
            )
          ],
        ),

      ) : Center(
        child: SpinKitChasingDots(color: Colors.deepPurple),
      )
    );
  }

  //staff audit list tile
  Widget _audit_tile(context, document, index) {
    return ListTile(
      dense: true,
      enabled: true,
      leading: Icon(Icons.av_timer),
      title: Text('Action ${document['action']}', style: TextStyle(fontFamily: "Roboto", fontSize: 14), maxLines: 2,),
      subtitle: Text('Entity : ${document['entityName']}', style: TextStyle(fontFamily: "Roboto", fontSize: 12), maxLines: 3,),
      trailing: Icon(Icons.arrow_forward, size: 24,),
      onTap: (){
        _showaudiDialog(document);
      },
    );
  }

  //shows staff audit log
  void _showaudiDialog(document) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Audit Log Request"),
          content: new Text(document['values'].toString().replaceAll("{", "").replaceAll("}", "").replaceAll(",", "\n").replaceAll(":", " = ")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
