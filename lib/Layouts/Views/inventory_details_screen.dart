import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Layouts/Views/create_damages_screen.dart';
import 'package:spree/Layouts/Views/create_returns_screen.dart';
import 'package:spree/Layouts/Views/create_transfer_screen.dart';
import 'package:spree/Utils/config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spree/Utils/fab-circular-menu.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/random_string.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'create_adjust_screen.dart';
import 'create_purchase_screen.dart';

class inventory_details_screen extends StatefulWidget {
  inventory_details_screen(this.product_data);
  final product_data;

  @override
  _inventory_details_screenState createState() =>
      _inventory_details_screenState(product_data);
}

class _inventory_details_screenState extends State<inventory_details_screen> {
  _inventory_details_screenState(this.product_data);
  final product_data;

  @override
  void initState() {
    super.initState();
    get_product_log();
    get_product_purchase_history();
    get_product_sales_history();
  }

  var product_purchase_documents;
  var product_sales_documents;

  var product_details;

  bool loaded = false;

  TextEditingController marginController = new TextEditingController();
  TextEditingController buyingController = new TextEditingController();

  //check if product exist our db
  Future<bool> get_product_log() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('productLogs')
        .where('productLogStall', isEqualTo: prefs.getString("stall_firestore_id"))
        .where('productLogProduct', isEqualTo: product_data["id"])
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    print("@@@" + documents.length.toString());
    if (documents.length == 1) {
      setState(() {
        product_details = documents;
        loaded = true;
      });
    } else if (documents.length == 0){

      dialog_create_product_log(context);
    }
    return documents.length == 1;
  }

  //get product purchase history
  Future<bool> get_product_purchase_history() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('purchases')
        .where("purchasesStallId", isEqualTo: prefs.getString("stall_firestore_id"))
        .where('purchasesProductId', isEqualTo: product_data["id"])
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      product_purchase_documents = documents;
    });

    return documents.length == 1;
  }

  //get product sales history
  Future<bool> get_product_sales_history() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('sales')
        .where('salesStallId', isEqualTo: prefs.getString("stall_firestore_id"))
        .where('salesItems', arrayContains: product_data["id"])
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      product_sales_documents = documents;
    });

    return documents.length == 1;
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
          title: Text(
            loaded == true
                ? product_data['productName'].toString().toUpperCase()
                : "Loading Product Details",
            style: TextStyle(
                fontFamily: "Roboto", fontSize: 17, color: Colors.grey[800]),
          ),
        ),
        body: loaded == true ?
        product_data['productEnableStock'] == "enabled" ?
        FabCircularMenu(
            child: ListView(
                children: <Widget>[
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      product_data['productImage'][0]['publicUrl'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                                languages.skeleton_language_objects[
                                config.app_language]['price'],
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                            subtitle: Text(
                              '${product_details != null ? product_details[0]['productLogSellingPrice'].toString() : "0"}',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[500],
                                  fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                                languages.skeleton_language_objects[
                                config.app_language]['inventory'],
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                            subtitle: Text(
                              product_details != null
                                  ? product_details[0]['productLogCurrentStock'].toString()
                                  : '0',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[500],
                                  fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                                languages.skeleton_language_objects[
                                config.app_language]['sold'],
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                            subtitle: Text(
                              '${product_details != null ? product_details[0]['productLogSoldUnits'] == null ? "0" : product_details[0]['productLogSoldUnits'].toString() : "0"}',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[500],
                                  fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  languages.skeleton_language_objects[
                                  config.app_language]['returned_units'],
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.grey[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center),
                              subtitle: Text(
                                '${product_details != null ? product_details[0]['productLogReturnedUnits'] == null ? "0" : product_details[0]['productLogReturnedUnits'].toString() : "0"}',
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[500],
                                    fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                          flex: 1,
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  languages.skeleton_language_objects[
                                  config.app_language]['transfered_units'],
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.grey[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center),
                              subtitle: Text(
                                product_details != null
                                    ? product_details[0]['productLogTransferredUnits'] == null ? "0" : product_details[0]['productLogTransferredUnits'].toString()
                                    : '0',
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[500],
                                    fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                                languages.skeleton_language_objects[
                                config.app_language]['adjusted_units'],
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                            subtitle: Text(
                              '${product_details != null ? product_details[0]['productLogAdjustedUnits'] == null ? "0" : product_details[0]['productLogAdjustedUnits'].toString() : "0"}',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[500],
                                  fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  languages.skeleton_language_objects[
                                  config.app_language]['damaged_units'],
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.grey[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center),
                              subtitle: Text(
                                '${product_details != null ? product_details[0]['productLogDamagedUnits'] == null ? "0" : product_details[0]['productLogDamagedUnits'].toString() : "0"}',
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[500],
                                    fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                          flex: 1,
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  languages.skeleton_language_objects[
                                  config.app_language]['purchased_units'],
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.grey[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center),
                              subtitle: Text(
                                product_details != null
                                    ? product_details[0]['productLogPurchasedUnits'] == null ? "0" : product_details[0]['productLogPurchasedUnits'].toString()
                                    : '0',
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[500],
                                    fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                                languages.skeleton_language_objects[
                                config.app_language]['total_purchased_units'],
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                            subtitle: Text(
                              '${product_details != null ? product_details[0]['purchaseTotalAmount'] == null ? "0" : product_details[0]['purchaseTotalAmount'].toString() : "0"}',
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[500],
                                  fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, right: 20, left: 20, bottom: 10),
                    child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['product_details'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Text(product_data['productDesc'] == null ? "N/A" : product_data['productDesc'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontSize: 13.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, right: 20, left: 20, bottom: 10),
                    child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['product_brand'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Text(
                        config.get_brand_by_id(
                            product_data['productBrand']),
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontSize: 13.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, right: 20, left: 20, bottom: 10),
                    child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['product_label_type'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Text(product_data['productCodeType'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontSize: 14.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, right: 20, left: 20, bottom: 10),
                    child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['product_unit'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Text(
                        config.get_unit_by_id(
                            product_data['productUnit'].toString()),
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontSize: 13.0,
                        )),
                  ),
                ],
              ),
          ringColor: Colors.deepPurple,
          options: <Widget>[
            IconButton(icon: Icon(Icons.add_to_photos), onPressed: () {
              var permission =  config.check_permissions("purchasesEditor");
              if(permission["can"] == true){
                Navigator.of(context).pop();
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new create_purchase_screen(product_data),
                );
                Navigator.of(context).push(route);
              } else {
                config.func_do_toast(permission["message"], Colors.purple);
              }
            }, iconSize: 32.0, color: Colors.white),
            IconButton(icon: Icon(Icons.transfer_within_a_station), onPressed: () {
              var permission =  config.check_permissions("stockTransferEditor");
              if(permission["can"] == true){
                Navigator.of(context).pop();
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new create_transfer_screen(product_data),
                );
                Navigator.of(context).push(route);
              } else {
                config.func_do_toast(permission["message"], Colors.purple);
              }
            }, iconSize: 32.0, color: Colors.white),
            IconButton(icon: Icon(Icons.block), onPressed: () {
              var permission =  config.check_permissions("damagesEditor");
              if(permission["can"] == true){
                Navigator.of(context).pop();
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new create_damages_screen(product_data),
                );
                Navigator.of(context).push(route);
              } else {
                config.func_do_toast(permission["message"], Colors.purple);
              }
            }, iconSize: 32.0, color: Colors.white),
            IconButton(icon: Icon(Icons.remove_shopping_cart), onPressed: () {
              var permission =  config.check_permissions("returnsEditor");
              if(permission["can"] == true){
                Navigator.of(context).pop();
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new create_returns_screen(product_data),
                );
                Navigator.of(context).push(route);
              } else {
                config.func_do_toast(permission["message"], Colors.purple);
              }
            }, iconSize: 32.0, color: Colors.white),
            IconButton(icon: Icon(Icons.settings_backup_restore), onPressed: () {
              var permission =  config.check_permissions("stockAdjustmentsEditor");
              if(permission["can"] == true){
                Navigator.of(context).pop();
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new create_adjust_screen(product_data),
                );
                Navigator.of(context).push(route);
              } else {
                config.func_do_toast(permission["message"], Colors.purple);
              }
            }, iconSize: 32.0, color: Colors.white),

          ],
        ) : ListView(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product_data['productImage'][0]['publicUrl'],
                fit: BoxFit.fill,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                            languages.skeleton_language_objects[
                            config.app_language]['price'],
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                        subtitle: Text(
                          '${product_details != null ? product_details[0]['productLogSellingPrice'].toString() : "0"}',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[500],
                              fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 45,
                  width: 1,
                  color: Colors.grey,
                ),
                Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                            languages.skeleton_language_objects[
                            config.app_language]['inventory'],
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                        subtitle: Text(
                          product_details != null
                              ? product_details[0]['productLogCurrentStock'].toString()
                              : '0',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[500],
                              fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 45,
                  width: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                          languages.skeleton_language_objects[
                          config.app_language]['sold'],
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                      subtitle: Text(
                        '${product_details != null ? product_details[0]['productLogSoldUnits'] == null ? "0" : product_details[0]['productLogSoldUnits'].toString() : "0"}',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.grey[500],
                            fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                            languages.skeleton_language_objects[
                            config.app_language]['returned_units'],
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                        subtitle: Text(
                          '${product_details != null ? product_details[0]['productLogReturnedUnits'] == null ? "0" : product_details[0]['productLogReturnedUnits'].toString() : "0"}',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[500],
                              fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 45,
                  width: 1,
                  color: Colors.grey,
                ),
                Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                            languages.skeleton_language_objects[
                            config.app_language]['transfered_units'],
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                        subtitle: Text(
                          product_details != null
                              ? product_details[0]['productLogTransferredUnits'] == null ? "0" : product_details[0]['productLogTransferredUnits'].toString()
                              : '0',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[500],
                              fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 45,
                  width: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                          languages.skeleton_language_objects[
                          config.app_language]['adjusted_units'],
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                      subtitle: Text(
                        '${product_details != null ? product_details[0]['productLogAdjustedUnits'] == null ? "0" : product_details[0]['productLogAdjustedUnits'].toString() : "0"}',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.grey[500],
                            fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                            languages.skeleton_language_objects[
                            config.app_language]['damaged_units'],
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                        subtitle: Text(
                          '${product_details != null ? product_details[0]['productLogDamagedUnits'] == null ? "0" : product_details[0]['productLogDamagedUnits'].toString() : "0"}',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[500],
                              fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 45,
                  width: 1,
                  color: Colors.grey,
                ),
                Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                            languages.skeleton_language_objects[
                            config.app_language]['purchased_units'],
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center),
                        subtitle: Text(
                          product_details != null
                              ? product_details[0]['productLogPurchasedUnits'] == null ? "0" : product_details[0]['productLogPurchasedUnits'].toString()
                              : '0',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[500],
                              fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 45,
                  width: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                          languages.skeleton_language_objects[
                          config.app_language]['total_purchased_units'],
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                      subtitle: Text(
                        '${product_details != null ? product_details[0]['purchaseTotalAmount'] == null ? "0" : product_details[0]['purchaseTotalAmount'].toString() : "0"}',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.grey[500],
                            fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 10, right: 20, left: 20, bottom: 10),
              child: Text(
                  languages.skeleton_language_objects[config.app_language]
                  ['product_details'],
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.deepPurple,
                    fontSize: 12.0,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
              child: Text(product_data['productDesc'] == null ? "N/A" : product_data['productDesc'],
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.grey[700],
                    fontSize: 13.0,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 20, right: 20, left: 20, bottom: 10),
              child: Text(
                  languages.skeleton_language_objects[config.app_language]
                  ['product_brand'],
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.deepPurple,
                    fontSize: 12.0,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
              child: Text(
                  config.get_brand_by_id(
                      product_data['productBrand']),
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.grey[700],
                    fontSize: 13.0,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 20, right: 20, left: 20, bottom: 10),
              child: Text(
                  languages.skeleton_language_objects[config.app_language]
                  ['product_label_type'],
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.deepPurple,
                    fontSize: 12.0,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
              child: Text(product_data['productCodeType'],
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.grey[700],
                    fontSize: 14.0,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 20, right: 20, left: 20, bottom: 10),
              child: Text(
                  languages.skeleton_language_objects[config.app_language]
                  ['product_unit'],
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.deepPurple,
                    fontSize: 12.0,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
              child: Text(
                  config.get_unit_by_id(
                      product_data['productUnit'].toString()),
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.grey[700],
                    fontSize: 13.0,
                  )),
            ),
          ],
        )
            : Center(
                child: SpinKitChasingDots(color: Colors.deepPurple),
              ));
  }

  dialog_create_product_log(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
        ['product_not_set']),
        content: Container(
          height : 190,
          child: ListView(
            children: <Widget>[
              Text(languages.skeleton_language_objects[config.app_language]
              ['product_doesnt_exist_on_store']),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextField(
                  maxLines: 1,
                  controller: buyingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText:
                      languages.skeleton_language_objects[config.app_language]['enter_buying_prince'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText:
                      languages.skeleton_language_objects[config.app_language]['enter_buying_prince'],
                      labelStyle: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto")),
                ),
              ),
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextField(
                  maxLines: 1,
                  controller: marginController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText:
                      languages.skeleton_language_objects[config.app_language]['enter_margin_prince'],
                      hintStyle: TextStyle(
                          fontSize: 14.0, fontFamily: "Roboto"),
                      labelText:
                      languages.skeleton_language_objects[config.app_language]['enter_margin_prince'],
                      labelStyle: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto")),
                ),
              ),

            ],
          ),
        ),
        actions: [
          new FlatButton(
            child: Text(languages.skeleton_language_objects[config.app_language]
            ['cancel']),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          new FlatButton(
            child: Text(
              languages.skeleton_language_objects[config.app_language]
              ['complete'],
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              if(marginController.text.isNotEmpty && buyingController.text.isNotEmpty){
                setState(() {
                  loaded = false;
                });
                create_product_log();
                Navigator.pop(context);
              } else {
                config.func_do_toast("Enter buying and margin price", Colors.red);
              }

            },
          ),
        ],
      ),
    );
  }

  create_product_log() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var product_log_id = randomAlphaNumeric(20);
    var values = {
      "createdAt" : FieldValue.serverTimestamp(),
      "createdBy" : prefs.getString("user_firestore_id"),
      "id" : product_log_id.toString(),
      "importHash" : null,
      "productLogAdjustRef" : [],
      "productLogBuyingPrice" : int.parse(buyingController.text),
      "productLogCurrentStock" : 0,
      "productLogDamageRef" : [],
      "productLogDamagedUnits" : 0,
      "productLogMargin" : int.parse(marginController.text),
      "productLogProduct" : product_data['id'],
      "productLogPurchaseRef" : [],
      "productLogPurchasedUnits" : 0,
      "productLogRef" : "${product_log_id.toString().substring(0,5)}",
      "productLogReturnedUnits" : 0,
      "productLogReturnsRef" : [],
      "productLogSaleRef" : [],
      "productLogSellingPrice" : (int.parse(marginController.text) + int.parse(buyingController.text)),
      "productLogSoldUnits" : 0,
      "productLogStall" : prefs.getString("stall_firestore_id"),
      "productLogTransferredRef" : [],
      "productLogTransferredUnits" : 0,
      "purchaseTotalAmount" : 0,
      "updatedAt" : FieldValue.serverTimestamp(),
      "updatedBy" : prefs.getString("user_firestore_id")
    };
    await config.create_a_record("productLogs", values, product_log_id);
    config.func_do_toast("Product Added to Store", Colors.green);
    setState(() {
      get_product_log();
      loaded = false;
    });
  }

}
