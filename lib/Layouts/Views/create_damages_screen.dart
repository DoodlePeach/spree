import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/random_string.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class create_damages_screen extends StatefulWidget {
  create_damages_screen(this.param);
  final param;

  @override
  _create_damages_screen createState() =>
      _create_damages_screen(param);
}

class _create_damages_screen extends State<create_damages_screen> {
  _create_damages_screen(this.param);
  final param;

  //text field
  TextEditingController refController = new TextEditingController();
  TextEditingController costController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  TextEditingController unitsController = new TextEditingController();

  var product_details;

  @override
  void initState() {
    super.initState();

    //fetch stores
    get_users();
    get_product_log();
  }

  //check if product exist our db
  Future<bool> get_product_log() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('productLogs')
        .where('productLogProduct', isEqualTo: param["id"])
        .where('productLogStall', isEqualTo: prefs.getString("stall_firestore_id"))
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1) {
      setState(() {
        product_details = documents;
        loaded = true;
      });
    }
    return documents.length == 1;
  }

  bool loaded = false;

  String selected_user = "Choose User";
  List<String> user_list_document = ["Choose User"];
  List<String> user_ids_list_document = [""];

  //get expenses
  Future<bool> get_users() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('user')
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      for (int i = 0; i < documents.length; i++) {
        user_list_document.add(documents[i]['fullName'].toString());
        user_ids_list_document.add(documents[i]['id']);
      }
    });
    return documents.length == 1;
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
          title: Text(
            languages.skeleton_language_objects[config.app_language]['product_damages_title'],
            style: TextStyle(
                fontFamily: "Roboto", fontSize: 15, color: Colors.grey[800]),
          ),
        ),
        body: loaded == true
            ? Container(
          height: double.infinity,
          margin: EdgeInsets.all(5),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                param['productName'],
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 17,
                    color: Colors.deepPurpleAccent),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Center(
                  child: Container(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 30),
                child: Text(
                  languages.skeleton_language_objects[config.app_language]['select_user'],
                  style: TextStyle(
                      color: Colors.deepOrange[200],
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Container(
                  child: DropdownButton<String>(
                    value: selected_user,
                    onChanged: (String newValue) {
                      setState(() {
                        selected_user = newValue;
                      });
                    },
                    items: user_list_document
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextField(
                  maxLines: 1,
                  controller: refController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText:
                      languages.skeleton_language_objects[config.app_language]['enter_ref_number'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText:
                      languages.skeleton_language_objects[config.app_language]['ref_no'],
                      labelStyle: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto")),
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextField(
                  maxLines: 1,
                  controller: unitsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText:
                      languages.skeleton_language_objects[config.app_language]['enter_receiving_quantity'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText: languages.skeleton_language_objects[config.app_language]['units'],
                      labelStyle: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto")),
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextField(
                  maxLines: 1,
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: languages.skeleton_language_objects[config.app_language]['product_cost'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText: languages.skeleton_language_objects[config.app_language]['product_cost'],
                      labelStyle: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto")),
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextField(
                  maxLines: 5,
                  controller: noteController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: languages.skeleton_language_objects[config.app_language]['enter_Reason'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText: languages.skeleton_language_objects[config.app_language]['enter_Reason'],
                      labelStyle: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto")),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                width: double.infinity,
                child: FlatButton(
                  child: Text(
                    languages.skeleton_language_objects[config.app_language]['create_damages'],
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                  color: Colors.deepOrange,
                  onPressed: () {
                    if(refController.text.isNotEmpty && costController.text.isNotEmpty && unitsController.text.isNotEmpty){
                      dialog_product_damages(context);
                    } else {
                      config.func_do_toast(languages.skeleton_language_objects[config.app_language]['enter_all_fields'], Colors.red);
                    }
                  },
                ),
              ),
            ],
          ),
        )
            : Center(
          child: SpinKitChasingDots(color: Colors.deepPurple),
        ));
      }


  dialog_product_damages(context) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
        ['create_damages']),
        content: Text(languages.skeleton_language_objects[config.app_language]
        ['confirm_create_damages']),
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
              create_product_damages();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //create product damages on fb
  create_product_damages() async{
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var damages_id = randomAlphaNumeric(20);
    var values = {
      "createdAt" : FieldValue.serverTimestamp(),
      "createdBy" : prefs.getString("user_firestore_id"),
      "damageAmmount" : int.parse(costController.text),
      "damageCausedBy" : [prefs.getString("user_firestore_id")],
      "damageCover" : [],
      "damageDate" : date.toString().substring(0,10),
      "damageDocs" : [],
      "damageNote" : noteController.text,
      "damageProduct" : param["id"],
      "damageRef" : unitsController.text + " " + param["productName"],
      "damageStall" : [prefs.getString("stall_firestore_id")],
      "id" : damages_id.toString(),
      "importHash" : null,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.create_a_record("damages", values, damages_id);
    product_update(damages_id);
  }

  //update product log
  product_update(damages_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int damages_units = int.parse(unitsController.text) + ( product_details[0]["productLogDamagedUnits"] == null ? 0 :  product_details[0]["productLogDamagedUnits"]);
    List damages = product_details[0]["productLogDamageRef"];
    List damages_list = [];
    if( product_details[0]["productLogDamageRef"] != []){
      for(var x in damages){
        damages_list.add(x);
      }
    }
    damages_list.add(damages_id);
    int new_units =  product_details[0]["productLogCurrentStock"] - int.parse(unitsController.text);

    var values = {
      "productLogDamagedUnits" : damages_units,
      "productLogCurrentStock" : new_units < 0 ? 0 : new_units,
      "productLogDamageRef" : damages_list,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    print("@@@@@@" + values.toString());
    await config.update_a_record("productLogs", values,  product_details[0]["id"]);
    config.func_do_toast("Product Damages created successfull", Colors.green);
    Navigator.pop(context);
  }


}
