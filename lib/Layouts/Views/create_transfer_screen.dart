import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/random_string.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class create_transfer_screen extends StatefulWidget {
  create_transfer_screen(this.param);
  final param;

  @override
  _create_transfer_screenState createState() =>
      _create_transfer_screenState(param);
}

class _create_transfer_screenState extends State<create_transfer_screen> {
  _create_transfer_screenState(this.param);
  final param;

  //text field
  TextEditingController refController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  TextEditingController unitsController = new TextEditingController();

  int status_value = -1;

  @override
  void initState() {
    super.initState();

    //fetch stores
    get_product_log();
    get_stores();
    get_expenses();
  }

  bool loaded = false;

  List<String> status_list = ["Choose Status", "Done", "Pending", "Active"];

  List<String> store_list_document = ["Choose Transfer Store"];
  List<String> ids_list_document = [""];

  String selected_stall = "Choose Transfer Store";
  String selected_status = "Choose Status";

  String selected_expense = "Choose Transfer Expense";
  List<String> expense_list_document = ["Choose Transfer Expense"];
  List<String> expense_ids_list_document = [""];

  var product_details;
  var other_product_details;

  //get store suppliers
  Future<bool> get_stores() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('stall').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      loaded = true;
      for (int i = 0; i < documents.length; i++) {
        store_list_document.add(documents[i]['stallName'].toString());
        ids_list_document.add(documents[i]['id']);
      }
    });
    return documents.length == 1;
  }

  //get expenses
  Future<bool> get_expenses() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('expenses').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      loaded = true;
      for (int i = 0; i < documents.length; i++) {
        expense_list_document.add(documents[i]['expensesTitle'].toString());
        expense_ids_list_document.add(documents[i]['id']);
      }
    });
    return documents.length == 1;
  }

  //check if product exist our db
  Future<bool> get_product_log() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('productLogs')
        .where('productLogProduct', isEqualTo: param[0]["id"])
        .where('productLogStall', isEqualTo: prefs.getString("stall_firestore_id"))
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    print("@@@" + documents.length.toString());
    if (documents.length == 1) {
      setState(() {
        product_details = documents;
        loaded = true;
      });
    }
    return documents.length == 1;
  }


  Future<bool> check_stall_product_log(stall_id) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('productLogs')
        .where('productLogProduct', isEqualTo: param[0]["id"])
        .where('productLogStall', isEqualTo: stall_id)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1) {
      other_product_details = documents;
      create_product_transfer();
    }
    else{
      config.func_do_toast("Stall does not have this product", Colors.green);
      Navigator.pop(context);
    }
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
            languages.skeleton_language_objects[config.app_language]
                ['product_transfer_title'],
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
                      param[0]['productName'],
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 17,
                          color: Colors.deepPurpleAccent),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Center(
                        child: Container(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['select_store'],
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
                          value: selected_stall,
                          onChanged: (String newValue) {
                            setState(() {
                              selected_stall = newValue;
                            });
                          },
                          items: store_list_document
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
                      margin: EdgeInsets.only(
                        left: 30,
                        top: 10,
                      ),
                      child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['select_expense'],
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
                          value: selected_expense,
                          onChanged: (String newValue) {
                            setState(() {
                              selected_expense = newValue;
                            });
                          },
                          items: expense_list_document
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
                      margin: EdgeInsets.only(
                        left: 30,
                        top: 10,
                      ),
                      child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['select_status'],
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
                          value: selected_status,
                          onChanged: (String newValue) {
                            setState(() {
                              selected_status = newValue;
                            });
                          },
                          items: status_list
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
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      child: TextField(
                        maxLines: 1,
                        controller: refController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: languages.skeleton_language_objects[
                                config.app_language]['enter_ref_number'],
                            hintStyle:
                                TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                            labelText: languages.skeleton_language_objects[
                                config.app_language]['ref_no'],
                            labelStyle: TextStyle(
                                fontSize: 12.0, fontFamily: "Roboto")),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      child: TextField(
                        maxLines: 1,
                        controller: unitsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: languages.skeleton_language_objects[config
                                .app_language]['enter_receiving_quantity'],
                            hintStyle:
                                TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                            labelText: languages.skeleton_language_objects[
                                config.app_language]['units'],
                            labelStyle: TextStyle(
                                fontSize: 12.0, fontFamily: "Roboto")),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      child: TextField(
                        maxLines: 5,
                        controller: noteController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: languages.skeleton_language_objects[
                                config.app_language]['enter_reason'],
                            hintStyle:
                                TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                            labelText: languages.skeleton_language_objects[
                                config.app_language]['enter_reason'],
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
                            groupValue: status_value,
                            onChanged: (int value) {
                              setState(() {
                                status_value = value;
                              });
                            },
                          ),
                          new Text(
                            'Done',
                            style: new TextStyle(fontSize: 14.0),
                          ),
                          new Radio(
                            value: 1,
                            groupValue: status_value,
                            onChanged: (int value) {
                              setState(() {
                                status_value = value;
                              });
                            },
                          ),
                          new Text(
                            'Pending',
                            style: new TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          new Radio(
                            value: 2,
                            groupValue: status_value,
                            onChanged: (int value) {
                              setState(() {
                                status_value = value;
                              });
                            },
                          ),
                          new Text(
                            'Active',
                            style: new TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
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
                          languages.skeleton_language_objects[
                              config.app_language]['create_transfer'],
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                        color: Colors.deepOrange,
                        onPressed: () {
                          if(unitsController.text.isNotEmpty && refController.text.isNotEmpty){
                            if(product_details[0]["productLogCurrentStock"] > int.parse(unitsController.text)){
                              dialog_create_transfer(context);
                            } else {
                              config.func_do_toast("You cant Transfer more than your inventory", Colors.red);
                            }
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

  dialog_create_transfer(context) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
        ['create_transfer']),
        content: Text(languages.skeleton_language_objects[config.app_language]
        ['you_are_about_to_create_a_transfer']),
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
              check_stall_product_log(ids_list_document[store_list_document.indexOf(selected_stall) - 1]);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  create_product_transfer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var product_transfer_id = randomAlphaNumeric(20);
    var values = {
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": prefs.getString("user_firestore_id"),
      "id": product_transfer_id.toString(),
      "importHash": null,
      "transferExpenses" : selected_expense == "" ? [] : [expense_ids_list_document[expense_list_document.indexOf(selected_expense) - 1]],
      "transferNote" : noteController.text,
      "transferProduct" : param[0]["id"],
      "transferRef" : "${product_transfer_id.toString().substring(0,5) + "-" + refController.text}",
      "transferStallFrom" : prefs.getString("stall_firestore_id"),
      "transferStallTo" : ids_list_document[store_list_document.indexOf(selected_stall) - 1],
      "transferStatus" : status_value == 0 ? "Done" : status_value == 1 ? "Pending" : "Active",
      "transferUnits" : int.parse(unitsController.text),
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };

    await config.create_a_record("stockTransfer", values, product_transfer_id);
    product_update_other_store(product_transfer_id);
    product_update_this_store(product_transfer_id);
  }

  product_update_other_store(product_transfer_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int new_units = int.parse(unitsController.text) + product_details[0]["productLogTransferredUnits"];
    List transfers = product_details[0]["productLogTransferredRef"];

    List transfer_list = [];
    if(transfers.isNotEmpty){
      for(var x in transfers){
        transfer_list.add(x);
      }
    }
    transfer_list.add(product_transfer_id);

    var values = {
      "productLogTransferredUnits" : new_units,
      "productLogCurrentStock" : (product_details[0]["productLogCurrentStock"] + int.parse(unitsController.text)),
      "productLogTransferredRef" : transfer_list,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.update_a_record("productLogs", values, product_details[0]["id"]);
    config.func_do_toast("${unitsController.text} Transfered successfull", Colors.green);
    Navigator.pop(context);
  }

  product_update_this_store(product_transfer_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int new_units = int.parse(unitsController.text) + product_details[0]["productLogTransferredUnits"];
    List transfers = product_details[0]["productLogTransferredRef"];

    List transfer_list = [];
    if(transfers.isNotEmpty){
      for(var x in transfers){
        transfer_list.add(x);
      }
    }
    transfer_list.add(product_transfer_id);

    var values = {
      "productLogTransferredUnits" : new_units,
      "productLogCurrentStock" : (product_details[0]["productLogCurrentStock"] - int.parse(unitsController.text)),
      "productLogTransferredRef" : transfer_list,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.update_a_record("productLogs", values, product_details[0]["id"]);
    config.func_do_toast("${unitsController.text} Transfered successfull", Colors.green);
    Navigator.pop(context);
  }


}
