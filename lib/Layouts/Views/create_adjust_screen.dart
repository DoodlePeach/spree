import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/random_string.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class create_adjust_screen extends StatefulWidget {
  create_adjust_screen(this.param);
  final param;

  @override
  _create_adjust_screen createState() =>
      _create_adjust_screen(param);
}

class _create_adjust_screen extends State<create_adjust_screen> {
  _create_adjust_screen(this.param);
  final param;

  int type_value = -1;
  int class_value = -1;

  //text field
  TextEditingController refController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  TextEditingController unitsController = new TextEditingController();

  TextEditingController lossController = new TextEditingController();
  TextEditingController recoveredController = new TextEditingController();

  var product_details;
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

  @override
  void initState() {
    get_product_log();
    super.initState();
  }

  bool loaded = false;

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
            languages.skeleton_language_objects[config.app_language]['create_adjust'],
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
                margin: EdgeInsets.only(top: 10, left: 10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: type_value,
                      onChanged: (int value){
                        setState(() {
                          type_value = value;
                        });
                      },
                    ),
                    new Text(
                      'Increase',
                      style: new TextStyle(fontSize: 14.0),
                    ),
                    new Radio(
                      value: 1,
                      groupValue: type_value,
                      onChanged: (int value){
                        setState(() {
                          type_value = value;
                        });
                      },
                    ),
                    new Text(
                      'Decrease',
                      style: new TextStyle(
                        fontSize: 14.0,
                      ),
                    )
                  ],
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
                  maxLines: 5,
                  controller: noteController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: languages.skeleton_language_objects[config.app_language]['enter_note'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText: languages.skeleton_language_objects[config.app_language]['enter_note'],
                      labelStyle: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto")),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: class_value,
                      onChanged: (int value){
                        setState(() {
                          class_value = value;
                        });
                      },
                    ),
                    new Text(
                      'Normal',
                      style: new TextStyle(fontSize: 14.0),
                    ),
                    new Radio(
                      value: 1,
                      groupValue: class_value,
                      onChanged: (int value){
                        setState(() {
                          class_value = value;
                        });
                      },
                    ),
                    new Text(
                      'Abnomal',
                      style: new TextStyle(
                        fontSize: 14.0,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextField(
                  maxLines: 1,
                  controller: lossController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: languages.skeleton_language_objects[config.app_language]['enter_loss_value'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText: languages.skeleton_language_objects[config.app_language]['enter_loss_value'],
                      labelStyle: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto")),
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextField(
                  maxLines: 1,
                  controller: recoveredController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: languages.skeleton_language_objects[config.app_language]['enter_recovered_value'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText: languages.skeleton_language_objects[config.app_language]['enter_recovered_value'],
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
                    languages.skeleton_language_objects[config.app_language]['create_adjust'],
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                  color: Colors.deepOrange,
                  onPressed: () {
                    if(refController.text.isNotEmpty && unitsController.text.isNotEmpty && type_value != -1 && class_value != -1){
                      dialog_create_adjust(context);
                    } else {
                      config.func_do_toast(languages.skeleton_language_objects[config.app_language]['enter_all_fields'], Colors.red);
                    }
                  },
                ),
              ),
            ],
          ),
        ) : Center(
          child: SpinKitChasingDots(color: Colors.deepPurple),
        ));
      }

      //create adjust dialog
  dialog_create_adjust(context) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
        ['create_adjust']),
        content: Text(languages.skeleton_language_objects[config.app_language]
        ['confirm_create_adjust']),
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
              setState(() {
                loaded = false;
              });
              create_product_adjust();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //create adjust on fb
  create_product_adjust() async{
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var adjust_id = randomAlphaNumeric(20);
    var values = {
      "adjustmentStall" : prefs.getString("stall_firestore_id"),
      "createdAt" : FieldValue.serverTimestamp(),
      "createdBy" : prefs.getString("user_firestore_id"),
      "id" : adjust_id.toString(),
      "importHash" : null,
      "stockAdjustmentClass" : class_value == -1 ? "Abnomal" : class_value == 0 ? "Normal" : "Abnormal" ,
      "stockAdjustmentLoss" : int.parse((lossController.text.isEmpty ? "0" : lossController.text)),
      "stockAdjustmentProduct" : param["id"],
      "stockAdjustmentRecorverdAmount" : int.parse(recoveredController.text.isEmpty ? "0" : recoveredController.text),
      "stockAdjustmentRef" : "${refController.text.toString().substring(0,4) + date.toString().substring(0,4)}",
      "stockAdjustmentType" : type_value == 0 ? "Increase" : "Decrease",
      "stockAdjustmentUnits" : int.parse(unitsController.text),
      "stockAdjustmentsReason" : noteController.text,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.create_a_record("stockAdjustments", values, adjust_id);
    product_update(adjust_id);
  }

  //update product log on fb
  product_update(adjust_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int adjust_units = int.parse(unitsController.text) + ( product_details[0]["productLogAdjustedUnits"] == null ? 0 :  product_details[0]["productLogAdjustedUnits"]);
    List adjusts = product_details[0]["productLogAdjustRef"];
    List adjusts_list = [];
    if( product_details[0]["productLogAdjustRef"] != []){
      for(var x in adjusts){
        adjusts_list.add(x);
      }
    }
    adjusts_list.add(adjust_id);
    int new_units = int.parse(unitsController.text);

    var values = {
      "productLogAdjustedUnits" : adjust_units,
      "productLogCurrentStock" : new_units < 0 ? 0 : new_units,
      "productLogAdjustRef" : adjusts_list,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.update_a_record("productLogs", values,  product_details[0]["id"]);
    config.func_do_toast("Product Adjust created successfull", Colors.green);
    Navigator.pop(context);
  }


}
