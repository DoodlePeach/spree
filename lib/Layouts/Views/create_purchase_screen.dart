import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/random_string.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class create_purchase_screen extends StatefulWidget {
  create_purchase_screen(this.param);
  final param;

  @override
  _create_purchase_screenState createState() =>
      _create_purchase_screenState(param);
}

class _create_purchase_screenState extends State<create_purchase_screen> {
  _create_purchase_screenState(this.param);
  final param;

  //text field
  TextEditingController refController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  TextEditingController unitsController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();

  var product_details;

  @override
  void initState() {
    super.initState();

    //fetch suppliers
    get_store_suppliers();
    get_product_log();
  }

  bool loaded = false;

  List<String> payment_status_list = [
    "Choose Payment Status",
    "Paid",
    "Pending"
  ];
  List<String> purchase_status_list = [
    "Choose Purchase Status",
    "Received",
    "Pending"
  ];

  List<String> supplier_list_document = ["Choose Supplier"];
  List<String> ids_list_document = ["supplier_id"];

  String selected_supplier = "Choose Supplier";
  String purchase_status = "Choose Purchase Status";
  String payment_status = "Choose Payment Status";

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
    print("@@@" + documents.length.toString());
    if (documents.length == 1) {
      setState(() {
        product_details = documents;
        loaded = true;
      });
    }
    return documents.length == 1;
  }

  //get store suppliers
  Future<bool> get_store_suppliers() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('suppliers')
        .where("supplierStatus", isEqualTo: "active")
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      loaded = true;
      for (int i = 0; i < documents.length; i++) {
        supplier_list_document.add(documents[i]['supplierNames'].toString());
        ids_list_document.add(documents[i]['id']);
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
            languages.skeleton_language_objects[config.app_language]
                ['title_make_purchase'],
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
                      margin: EdgeInsets.all(15),
                      child: Center(
                        child: Container(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Container(
                        child: DropdownButton<String>(
                          value: selected_supplier,
                          onChanged: (String newValue) {
                            setState(() {
                              selected_supplier = newValue;
                            });
                          },
                          items: supplier_list_document
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
                      margin: EdgeInsets.only(left: 30),
                      child: Container(
                        child: DropdownButton<String>(
                          value: purchase_status,
                          onChanged: (String newValue) {
                            setState(() {
                              purchase_status = newValue;
                            });
                          },
                          items: purchase_status_list
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
                      margin: EdgeInsets.only(left: 30),
                      child: Container(
                        child: DropdownButton<String>(
                          value: payment_status,
                          onChanged: (String newValue) {
                            setState(() {
                              payment_status = newValue;
                            });
                          },
                          items: payment_status_list
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
                        maxLines: 5,
                        controller: noteController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: languages.skeleton_language_objects[
                            config.app_language]['enter_note'],
                            hintStyle:
                            TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                            labelText: languages.skeleton_language_objects[
                            config.app_language]['enter_note'],
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
                        maxLines: 1,
                        controller: totalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: languages.skeleton_language_objects[config
                                .app_language]['enter_single_product_cost'],
                            hintStyle:
                                TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                            labelText: languages.skeleton_language_objects[
                                config.app_language]['product_cost'],
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
                          languages.skeleton_language_objects[
                              config.app_language]['create_product'],
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                        color: Colors.deepOrange,
                        onPressed: () {
                          if (totalController.text.isNotEmpty &&
                              unitsController.text.isNotEmpty &&
                              refController.text.isNotEmpty &&
                              !selected_supplier.contains(languages
                                      .skeleton_language_objects[config.app_language]
                                  ['choose']) &&
                              !purchase_status.contains(
                                  languages.skeleton_language_objects[
                                      config.app_language]['choose']) &&
                              !payment_status.contains(
                                  languages.skeleton_language_objects[
                                      config.app_language]['choose'])) {
                            dialog_create_purchase(context);
                          } else {
                            config.func_do_toast(
                                languages.skeleton_language_objects[
                                    config.app_language]['enter_all_fields'],
                                Colors.red);
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

  dialog_create_purchase(context) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
            ['create_attendance']),
        content: Text(languages.skeleton_language_objects[config.app_language]
            ['confirm_create_purchase']),
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
              create_product_purchase();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  create_product_purchase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var purchase_id = randomAlphaNumeric(20);
    var values = {
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": prefs.getString("user_firestore_id"),
      "id": purchase_id.toString(),
      "importHash": null,
      "purchaseNote" : noteController.text,
      "purchasePaymentStatus" : payment_status,
      "purchaseProduct" : param["id"],
      "purchaseReturnsReason" : null,
      "purchaseReturnsUnits" : null,
      "purchaseStall" : prefs.getString("stall_firestore_id"),
      "purchaseSupplier" : ids_list_document[supplier_list_document.indexOf(selected_supplier) - 0],
      "purchaseTotalAmount" : int.parse(totalController.text),
      "purchaseUnits" : int.parse(unitsController.text),
      "purchasesRef" : "${purchase_id.toString().substring(0,7)}",
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.create_a_record("purchases", values, purchase_id);
    if(int.parse(totalController.text) != product_details[0]["productLogBuyingPrice"]){
      print("@##@#@" + product_details[0]["productLogBuyingPrice"].toString());
      create_product_price_change(product_details[0], purchase_id);
    } else {
      product_update(product_details[0], purchase_id);
    }
  }

  create_product_price_change(product_log, purchase_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var price_change_id = randomAlphaNumeric(20);
    var values = {
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": prefs.getString("user_firestore_id"),
      "id": price_change_id.toString(),
      "importHash": null,
      "priceChangeAfter" : int.parse(totalController.text),
      "priceChangeBefore" : product_log["productLogSellingPrice"],
      "priceChangeProduct" : param["id"],
      "priceChangeRef" : "${price_change_id.toString().substring(0,7)}",
      "priceChangeSession" : prefs.getString("device_session_id"),
      "priceChangeStall" : prefs.getString("stall_firestore_id"),
      "priceChangeStatus" : "Completed",
      "priceChangeType" : "Buying",
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.create_a_record("priceChange", values, price_change_id);
    product_update(product_log, purchase_id);
  }

  product_update(product_log, purchase_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int selling_price = int.parse(totalController.text) + product_log["productLogMargin"];
    int new_units = int.parse(unitsController.text) + product_log["productLogPurchasedUnits"];
    List purchases = product_log["productLogPurchaseRef"];
    List purchase_list = [];
    if(product_log["productLogPurchaseRef"] != []){
      for(var x in purchases){
        purchase_list.add(x);
      }
    }
    purchase_list.add(purchase_id);
    print("@@@" + purchases.length.toString());

    int total_purchase = product_log["purchaseTotalAmount"] + (int.parse(totalController.text) * int.parse(unitsController.text));
    var values = {
      "productLogBuyingPrice" : int.parse(totalController.text),
      "productLogSellingPrice" : selling_price,
      "productLogPurchasedUnits" : new_units,
      "productLogCurrentStock" : (product_log["productLogCurrentStock"] + int.parse(unitsController.text)),
      "productLogPurchaseRef" : purchase_list,
      "purchaseTotalAmount" : total_purchase,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.update_a_record("productLogs", values, product_log["id"]);
    config.func_do_toast("Purchase and price change successfull", Colors.green);
    Navigator.pop(context);
  }

}
