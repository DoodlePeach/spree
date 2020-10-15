//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
////import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:spree/Layouts/Views/dashboard_screen.dart';
//import 'package:spree/Utils/config.dart';
//import 'package:spree/Utils/random_string.dart';
//import 'package:pdf/widgets.dart' as pdf;
//import 'package:printing/printing.dart';
//
//import 'dart:async';
//import 'dart:convert';
//import 'package:flutter/services.dart';
//
//import 'package:spree/Utils/languages.dart';
//import 'package:pdf/pdf.dart';
//
//class pos_screen extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _pos_screenState();
//  }
//}
//
//class _pos_screenState extends State<pos_screen> {
//  Stream<QuerySnapshot> stream;
//
//  int count = 0;
//  bool loaded = false;
//  int total_amount = 0;
//  double total_tax_amount = 0;
//  int total_items = 0;
//  var receipt_data;
//  var product_units;
//  var store_product_logs, store_inventory;
//
//  GlobalKey btnKey = GlobalKey();
//
//  //cart lists
//  List<String> cart_list_ids = new List();
//  List<String> cart_list_name = new List();
//  List<int> cart_list_count = new List();
//  List<int> cart_list_value = new List();
//  List<int> cart_list_stock = new List();
//  List<int> cart_list_tax = new List();
//  List product_log = new List();
//
//  List<String> product_attributes_list_ids = new List();
//
//  List<bool> customer_list = new List();
//
//  var customer_data;
//  bool order_limit = false;
//  var stall_firestore_id;
//
//  //text field controller
//  TextEditingController discountController = new TextEditingController();
//  TextEditingController bankNoteController = new TextEditingController();
//  TextEditingController skuController = new TextEditingController();
//
//  @override
//  void initState() {
//    super.initState();
//    store_product_logs = config.store_product_logs;
//    store_inventory = config.store_inventory;
//    get_data();
//    loaded = true;
//  }
//
//
//  get_data() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    stall_firestore_id = prefs.getString("stall_firestore_id");
//
//    CollectionReference collectionReference =
//    Firestore.instance.collection('products');
//    setState(() {
//      stream = collectionReference.limit(100).snapshots();
//    });
//  }
//
////  func_scaner() async {
////    String barcodeScanRes;
////    // Platform messages may fail, so we use a try/catch PlatformException.
////    try {
////      barcodeScanRes =
////      await FlutterBarcodeScanner.scanBarcode("#ff6666", "Stop", true);
////
////    } on PlatformException {
////      barcodeScanRes = 'Failed to get platform version.';
////    }
////
////    if (!mounted) return;
////    setState(() {
////    });
////  }
//
//  //search dialog.
//  _searchDialog(context) {
//    showDialog(
//      context: context,
//      child: new AlertDialog(
//        title: Text(languages.skeleton_language_objects[config.app_language]
//        ['scan_or_enter_keyword']),
//        content: Container(
//          height: 200,
//          child: Column(
//            children: <Widget>[
//              Text(languages.skeleton_language_objects[config.app_language]
//              ['enter_keyword_or_barcode']),
//              SizedBox(height: 10),
//              TextField(
//                maxLines: 1,
//                controller: skuController,
//                autofocus: true,
//                keyboardType: TextInputType.text,
//                decoration: InputDecoration(
//                    hintText:
//                    languages.skeleton_language_objects[config.app_language]
//                    ['enter_keyword_or_barcode'],
//                    hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
//                    labelText:
//                    languages.skeleton_language_objects[config.app_language]
//                    ['enter_keyword_or_barcode'],
//                    labelStyle:
//                    TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
//              ),
//              SizedBox(height: 15),
//            ],
//          ),
//        ),
//        actions: [
//          new FlatButton(
//            child: Text(languages.skeleton_language_objects[config.app_language]
//            ['cancel']),
//            onPressed: () => Navigator.pop(context),
//          ),
//          new FlatButton(
//            child: Text(
//              languages.skeleton_language_objects[config.app_language]
//              ['confirm'],
//              style: TextStyle(color: Colors.teal),
//            ),
//            onPressed: () {
//              if (skuController.text != null && skuController.text != "") {
////                CollectionReference collectionReference =
////                Firestore.instance.collection('products');
////                stream = collectionReference.limit(100).snapshots();
//                Navigator.pop(context);
//              } else {
//                config.func_do_toast(
//                    languages.skeleton_language_objects[config.app_language]
//                    ['you_need_to_enter_keyword'],
//                    Colors.red);
//              }
//            },
//          ),
//        ],
//      ),
//    );
//  }
//
//  //this func generates a pdf
//  List<int> func_generate_pdf(PdfPageFormat format) {
//    final pdf.Document doc = pdf.Document();
//
//    doc.addPage(pdf.Page(build: (pdf.Context context) {
//      return pdf.Center(
//        child: pdf.Column(children: <pdf.Widget>[
//          pdf.Text(config.app_name.toUpperCase(),
//              style:
//              pdf.TextStyle(fontSize: 32, fontWeight: pdf.FontWeight.bold)),
//          pdf.SizedBox(height: 25),
//          pdf.Text(
//              " ${languages.skeleton_language_objects[config.app_language]['for_enquiries_call']} : ${config.app_contacts}",
//              style: pdf.TextStyle(fontSize: 22)),
//          pdf.SizedBox(height: 5),
//          pdf.Text("${config.app_po_box}", style: pdf.TextStyle(fontSize: 22)),
//          pdf.SizedBox(height: 5),
//          pdf.Text(
//              "${languages.skeleton_language_objects[config.app_language]['receipt']} # ${receipt_data['receipt_no']}",
//              style: pdf.TextStyle(fontSize: 20)),
//          pdf.SizedBox(height: 5),
//          pdf.Text("${receipt_data['date_time']}",
//              style: pdf.TextStyle(fontSize: 20)),
//          pdf.SizedBox(height: 30),
//          pdf.Container(
//            alignment: pdf.Alignment.topLeft,
//            child: pdf.Text("${receipt_data['items_list'].toString()}",
//                style: pdf.TextStyle(
//                    fontSize: 22, fontWeight: pdf.FontWeight.normal),
//                textAlign: pdf.TextAlign.left),
//          ),
//          pdf.SizedBox(height: 30),
//          pdf.Container(
//              child: pdf.Row(children: <pdf.Widget>[
//                pdf.Expanded(
//                  flex: 1,
//                  child: pdf.Text(
//                      languages.skeleton_language_objects[config.app_language]
//                      ['total_amount'],
//                      style: pdf.TextStyle(
//                          fontSize: 20, fontWeight: pdf.FontWeight.bold),
//                      textAlign: pdf.TextAlign.left),
//                ),
//                pdf.Expanded(
//                  flex: 1,
//                  child: pdf.Text("${receipt_data['total_amount']}",
//                      style: pdf.TextStyle(fontSize: 20),
//                      textAlign: pdf.TextAlign.right),
//                ),
//              ])),
//          pdf.SizedBox(height: 10),
//          pdf.Container(
//              child: pdf.Row(children: <pdf.Widget>[
//                pdf.Expanded(
//                  flex: 1,
//                  child: pdf.Text(
//                      languages.skeleton_language_objects[config.app_language]
//                      ['total_items'],
//                      style: pdf.TextStyle(
//                          fontSize: 20, fontWeight: pdf.FontWeight.bold),
//                      textAlign: pdf.TextAlign.left),
//                ),
//                pdf.Expanded(
//                  flex: 1,
//                  child: pdf.Text("${receipt_data['total_items']}",
//                      style: pdf.TextStyle(fontSize: 20),
//                      textAlign: pdf.TextAlign.right),
//                ),
//              ])),
//          pdf.SizedBox(height: 10),
//          pdf.Container(
//              height: 35,
//              child: pdf.Row(children: <pdf.Widget>[
//                pdf.Expanded(
//                  flex: 1,
//                  child: pdf.Text(
//                      languages.skeleton_language_objects[config.app_language]
//                      ['total_tax'],
//                      style: pdf.TextStyle(
//                          fontSize: 20, fontWeight: pdf.FontWeight.bold),
//                      textAlign: pdf.TextAlign.left),
//                ),
//                pdf.Expanded(
//                  flex: 1,
//                  child: pdf.Text("${receipt_data['total_tax_amount']}",
//                      style: pdf.TextStyle(fontSize: 20),
//                      textAlign: pdf.TextAlign.right),
//                ),
//              ])),
//          pdf.SizedBox(height: 35),
//          pdf.Text(
//              languages.skeleton_language_objects[config.app_language]
//              ['thant_you_and_come_again'],
//              style: pdf.TextStyle(fontSize: 24)),
//          pdf.Text("FISCAL PRINTER",
//              style: pdf.TextStyle(fontSize: 24),
//              textAlign: pdf.TextAlign.center),
//          pdf.SizedBox(height: 10),
//        ]),
//      ); // Center
//    }));
//
//    return doc.save();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          iconTheme: IconThemeData(
//            color: Colors.grey[800], //change your color here
//          ),
//          backgroundColor: Colors.grey[200],
//          elevation: 3,
//          title: Text(
//            languages.skeleton_language_objects[config.app_language]
//            ['make_sale'],
//            style: TextStyle(
//                fontFamily: "Roboto",
//                fontSize: 18,
//                color: Colors.grey[700],
//                fontWeight: FontWeight.w500),
//          ),
//          actions: <Widget>[
//            IconButton(
//              onPressed: () {
//                dashboard_screenState.get_store_product_logs();
//              },
//              icon: Icon(
//                Icons.refresh,
//                color: Colors.grey[700],
//                size: 24,
//              ),
//            ),
//            IconButton(
//              onPressed: () {
//
////                _searchDialog(context);
//              },
//              icon: Icon(
//                Icons.camera,
//                color: Colors.grey[700],
//                size: 24,
//              ),
//            ),
//            receipt_data != null
//                ? IconButton(
//              onPressed: () {
//                Printing.layoutPdf(
//                  onLayout: func_generate_pdf,
//                );
//              },
//              icon: Icon(
//                Icons.print,
//                color: Colors.green[700],
//                size: 24,
//              ),
//            )
//                : Container()
//          ],
//        ),
//        drawer: Drawer(
//          child: ListView(
//            padding: EdgeInsets.zero,
//            children: <Widget>[
//              DrawerHeader(
//                child: Column(
//                  children: <Widget>[
//                    ListTile(
//                      dense: true,
//                      enabled: true,
//                      leading: Icon(Icons.dns, color: Colors.purple),
//                      title: Text(
//                          languages.skeleton_language_objects[
//                          config.app_language]['total_product_on_cart'],
//                          style: TextStyle(
//                              fontFamily: "Roboto", color: Colors.deepPurple)),
//                      subtitle: Text(
//                          languages.skeleton_language_objects[
//                          config.app_language]['total_items_on_cart'],
//                          style: TextStyle(
//                              fontFamily: "Roboto", color: Colors.purple)),
//                      trailing: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Text('${cart_list_ids.length}',
//                              style: TextStyle(
//                                  fontFamily: "Roboto", color: Colors.black)),
//                          Text(total_items.toString(),
//                              style: TextStyle(
//                                  fontFamily: "Roboto", color: Colors.black))
//                        ],
//                      ),
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                    ),
//                    ListTile(
//                      dense: true,
//                      enabled: true,
//                      leading:
//                      Icon(Icons.fiber_smart_record, color: Colors.purple),
//                      title: Text(
//                          languages.skeleton_language_objects[
//                          config.app_language]['total_amount_on_cart'],
//                          style: TextStyle(
//                              fontFamily: "Roboto", color: Colors.deepPurple)),
//                      subtitle: Text(
//                          languages.skeleton_language_objects[
//                          config.app_language]['total_tax_amount_on_cart'],
//                          style: TextStyle(
//                              fontFamily: "Roboto", color: Colors.purple)),
//                      trailing: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Text('${total_amount.toString()}',
//                              style: TextStyle(
//                                  fontFamily: "Roboto", color: Colors.black)),
//                          Text(total_tax_amount.toString(),
//                              style: TextStyle(
//                                  fontFamily: "Roboto", color: Colors.black))
//                        ],
//                      ),
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                    ),
//                  ],
//                ),
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                ),
//              ),
//              Container(
//                height: 80.0 * cart_list_ids.length,
//                child: ListView.builder(
//                    physics: const NeverScrollableScrollPhysics(),
//                    itemCount: cart_list_ids.length,
//                    itemBuilder: (BuildContext ctxt, int index) {
//                      return new ListTile(
//                        dense: true,
//                        enabled: false,
//                        title: Text(
//                          '${cart_list_name[index].toString()}',
//                          style: TextStyle(
//                              fontFamily: "Roboto", color: Colors.black),
//                          maxLines: 1,
//                        ),
//                        subtitle: Text(
//                            '${cart_list_value[index].toString()} X ${cart_list_count[index].toString()} = ${(cart_list_value[index] * cart_list_count[index]).toString()}',
//                            style: TextStyle(
//                                fontFamily: "Roboto", color: Colors.grey[800])),
//                        trailing: Container(
//                          width: 100,
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              IconButton(
//                                onPressed: () {
//                                  if (cart_list_stock[index] >
//                                      cart_list_count[index]) {
//                                    int cart_position = index;
//                                    int current_value =
//                                    cart_list_count[cart_position];
//                                    int new_value = current_value + 1;
//
//                                    setState(() {
//                                      cart_list_count[cart_position] =
//                                          new_value;
//                                      get_total_amount_value();
//                                      get_total_items_on_cart();
//                                      get_total_tax_amount_value();
//                                    });
//                                  } else {
//                                    config.func_do_toast(
//                                        languages.skeleton_language_objects[
//                                        config.app_language]
//                                        ['product_inventory_empty'],
//                                        Colors.red);
//                                  }
//                                },
//                                icon: Icon(
//                                  Icons.add_box,
//                                  color: Colors.green[800],
//                                  size: 35,
//                                ),
//                              ),
//                              IconButton(
//                                onPressed: () {
//                                  int cart_position = index;
//                                  int current_value =
//                                  cart_list_count[cart_position];
//
//                                  if (current_value == 1) {
//                                    setState(() {
//                                      cart_list_ids.removeAt(cart_position);
//                                      cart_list_name.removeAt(cart_position);
//                                      cart_list_count.removeAt(cart_position);
//                                      cart_list_value.removeAt(cart_position);
//                                      cart_list_stock.removeAt(cart_position);
//                                      cart_list_tax.removeAt(cart_position);
//                                      product_log.removeAt(cart_position);
//                                      product_attributes_list_ids
//                                          .removeAt(cart_position);
//                                      get_total_amount_value();
//                                      get_total_items_on_cart();
//                                      get_total_tax_amount_value();
//                                    });
//                                    config.func_do_toast(
//                                        languages.skeleton_language_objects[
//                                        config.app_language]
//                                        ['msg_item_removed'],
//                                        Colors.red);
//                                  } else {
//                                    int new_value = current_value - 1;
//
//                                    setState(() {
//                                      cart_list_count[cart_position] =
//                                          new_value;
//                                      get_total_amount_value();
//                                      get_total_items_on_cart();
//                                      get_total_tax_amount_value();
//                                    });
//                                  }
//                                },
//                                icon: Icon(
//                                  Icons.indeterminate_check_box,
//                                  color: Colors.red[800],
//                                  size: 35,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                        onTap: () {},
//                      );
//                    }),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Center(
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        Container(
//                          width: 20,
//                        ),
//                        Expanded(
//                          flex: 1,
//                          child: PopupMenuButton(
//                            itemBuilder: (context) {
//                              var list = List<PopupMenuEntry<Object>>();
//                              list.add(
//                                PopupMenuItem(
//                                  child: Text(
//                                    languages.skeleton_language_objects[
//                                    config.app_language]['choose_customer'],
//                                    style: TextStyle(color: Colors.black),
//                                  ),
//                                  value: 0,
//                                ),
//                              );
//                              list.add(
//                                PopupMenuDivider(
//                                  height: 10,
//                                ),
//                              );
//
//                              for (var x in config.store_customers) {
//                                customer_list.add(false);
//                                list.add(
//                                  CheckedPopupMenuItem(
//                                    child: Text(
//                                      "${x['customerNames']}",
//                                      style: TextStyle(color: Colors.black),
//                                    ),
//                                    value:
//                                    "${x['id'] + ':' + x['customerNames']}",
//                                    checked: false,
//                                  ),
//                                );
//                              }
//
//                              return list;
//                            },
//                            onSelected: (value) {
//                              setState(() {
//                                if (config.get_customer_order_limit(
//                                    value.toString().split(":")[0]) >=
//                                    total_amount) {
//                                  setState(() {
//                                    customer_data = value;
//                                    order_limit = true;
//                                  });
//                                } else {
//                                  setState(() {
//                                    customer_data = value;
//                                    order_limit = false;
//                                  });
//                                }
//                              });
//                            },
//                            icon: Icon(
//                              Icons.person_outline,
//                              size: 26,
//                              color: Colors.blueGrey,
//                            ),
//                          ),
//                        ),
//                        Container(
//                          width: 20,
//                        ),
//                        Expanded(
//                          flex: 1,
//                          child: PopupMenuButton(
//                            itemBuilder: (context) {
//                              var list = List<PopupMenuEntry<Object>>();
//                              list.add(
//                                PopupMenuItem(
//                                  child: Text(
//                                    languages.skeleton_language_objects[
//                                    config.app_language]['enter_discount'],
//                                    style: TextStyle(color: Colors.black),
//                                  ),
//                                  value: 0,
//                                ),
//                              );
//                              list.add(
//                                PopupMenuDivider(
//                                  height: 20,
//                                ),
//                              );
//                              list.add(
//                                CheckedPopupMenuItem(
//                                  child: TextField(
//                                    maxLines: 1,
//                                    controller: discountController,
//                                    keyboardType: TextInputType.number,
//                                    decoration: InputDecoration(
//                                        hintText:
//                                        languages.skeleton_language_objects[
//                                        config.app_language]
//                                        ['enter_sale_discount'],
//                                        hintStyle: TextStyle(
//                                            fontSize: 14.0,
//                                            fontFamily: "Roboto"),
//                                        labelText:
//                                        languages.skeleton_language_objects[
//                                        config.app_language]
//                                        ['sale_discount'],
//                                        labelStyle: TextStyle(
//                                            fontSize: 12.0,
//                                            fontFamily: "Roboto")),
//                                  ),
//                                  value:
//                                  "${discountController.text.length > 1 ? discountController.text : 0} ",
//                                  checked: false,
//                                ),
//                              );
//                              list.add(
//                                PopupMenuDivider(
//                                  height: 20,
//                                ),
//                              );
//                              return list;
//                            },
//                            onSelected: (value) {
//                              setState(() {
//                                customer_data = value;
//                              });
//                            },
//                            icon: Icon(
//                              Icons.donut_large,
//                              size: 26,
//                              color: Colors.blueGrey,
//                            ),
//                          ),
//                        ),
//                        Container(
//                          width: 20,
//                        ),
//                      ],
//                    ),
//                    SizedBox(
//                      height: 10,
//                    )
//                  ],
//                ),
//              ),
//              Container(
//                color: Colors.grey[200],
//                height: 160,
//                child: Column(
//                  children: <Widget>[
//                    Expanded(
//                      flex: 1,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                        children: <Widget>[
//                          Expanded(
//                            flex: 1,
//                            child: GestureDetector(
//                                onTap: () {
//                                  func_offline_checkout(context);
//                                },
//                                child: Container(
//                                  height: 75,
//                                  child: Card(
//                                    elevation: 1,
//                                    color: Colors.white,
//                                    child: ListTile(
//                                      dense: true,
//                                      enabled: false,
//                                      title: Text(
//                                          languages.skeleton_language_objects[
//                                          config.app_language]['cash'],
//                                          style: TextStyle(
//                                              fontFamily: "Roboto",
//                                              color: Colors.black)),
//                                      subtitle: Text(
//                                          languages.skeleton_language_objects[
//                                          config.app_language]['cash'],
//                                          style: TextStyle(
//                                              fontFamily: "Roboto",
//                                              color: Colors.grey[800])),
//                                      trailing: Icon(
//                                        Icons.attach_money,
//                                        color: Colors.green[800],
//                                        size: 25,
//                                      ),
//                                      onTap: () {
//                                        get_stripe_payment();
//                                      },
//                                    ),
//                                  ),
//                                )),
//                          ),
//                          Expanded(
//                              flex: 1,
//                              child: GestureDetector(
//                                onTap: () {
//                                  config.func_do_toast(
//                                      languages.skeleton_language_objects[
//                                      config.app_language]
//                                      ['online_payments_comming_soon'],
//                                      Colors.blue);
////                                  func_show_online_popupmenu();
//                                },
//                                child: Container(
//                                  height: 75,
//                                  child: Card(
//                                    elevation: 1,
//                                    color: Colors.white,
//                                    child: ListTile(
//                                      dense: true,
//                                      enabled: false,
//                                      title: Text(
//                                          languages.skeleton_language_objects[
//                                          config.app_language]['online'],
//                                          style: TextStyle(
//                                              fontFamily: "Roboto",
//                                              color: Colors.black)),
//                                      subtitle: Text('Pay Online',
//                                          style: TextStyle(
//                                              fontFamily: "Roboto",
//                                              color: Colors.grey[800])),
//                                      trailing: Icon(
//                                        Icons.network_check,
//                                        color: Colors.green[800],
//                                        size: 25,
//                                      ),
//                                      onTap: () {},
//                                    ),
//                                  ),
//                                ),
//                              )),
//                        ],
//                      ),
//                    ),
//                    Expanded(
//                      flex: 1,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                        children: <Widget>[
//                          Expanded(
//                              flex: 1,
//                              child: GestureDetector(
//                                child: Container(
//                                  height: 75,
//                                  child: Card(
//                                    elevation: 1,
//                                    color: Colors.white,
//                                    child: ListTile(
//                                      dense: true,
//                                      enabled: false,
//                                      title: Text(
//                                          languages.skeleton_language_objects[
//                                          config.app_language]['credit'],
//                                          style: TextStyle(
//                                              fontFamily: "Roboto",
//                                              color: Colors.black)),
//                                      subtitle: Text(
//                                          languages.skeleton_language_objects[
//                                          config.app_language]
//                                          ['pay_by_credit'],
//                                          style: TextStyle(
//                                              fontFamily: "Roboto",
//                                              color: Colors.grey[800])),
//                                      trailing: Icon(
//                                        Icons.person_pin,
//                                        color: Colors.green[800],
//                                        size: 25,
//                                      ),
//                                      onTap: () {},
//                                    ),
//                                  ),
//                                ),
//                                onTap: () {
//                                  if (order_limit == true) {
//                                    func_credit_checkout(context);
//                                  } else {
//                                    config.func_do_toast(
//                                        languages.skeleton_language_objects[
//                                        config.app_language][
//                                        'customer_order_limit_is_below'] +
//                                            ' $total_amount',
//                                        Colors.red);
//                                  }
//                                },
//                              )),
//                          Expanded(
//                              flex: 1,
//                              child: GestureDetector(
//                                onTap: () {
//                                  func_offline_bank_checkout(context);
//                                },
//                                child: Container(
//                                  height: 75,
//                                  child: Card(
//                                    elevation: 1,
//                                    color: Colors.white,
//                                    child: ListTile(
//                                      dense: true,
//                                      enabled: false,
//                                      title: Text(
//                                          languages.skeleton_language_objects[
//                                          config.app_language]['bank'],
//                                          style: TextStyle(
//                                              fontFamily: "Roboto",
//                                              color: Colors.black)),
//                                      subtitle: Text(
//                                          languages.skeleton_language_objects[
//                                          config.app_language]
//                                          ['pay_by_bank'],
//                                          style: TextStyle(
//                                              fontFamily: "Roboto",
//                                              color: Colors.grey[800])),
//                                      trailing: Icon(
//                                        Icons.swap_vert,
//                                        color: Colors.green[800],
//                                        size: 25,
//                                      ),
//                                      onTap: () {
////                                      offline_check_out();
//                                      },
//                                    ),
//                                  ),
//                                ),
//                              )),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              Container(
//                color: Colors.grey[300],
//                height: 200,
//              )
//            ],
//          ),
//        ),
//        body: StreamBuilder(
//            stream: stream,
//            builder: (context, snapshot) {
//              if (!snapshot.hasData)
//                return Center(
//                  child: SpinKitChasingDots(color: Colors.deepPurple),
//                );
//              count = snapshot.data.documents.length;
//              return new GridView.builder(
//                itemCount: snapshot.data.documents.length,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount: 3),
//                itemBuilder: (context, index) => _inventory_tile(
//                    context, snapshot.data.documents[index], index),
//              );
//            }));
//  }
//
//  //to be implemented in the future
//  get_stripe_payment() {}
//
//  //this list items
//  Widget _inventory_tile(context, document, index) {
//    return Container(
//      margin: EdgeInsets.all(2),
//      child: GestureDetector(
//        onTap: () {
//          if (document['productAttribute'] == null ||
//              document['productAttribute'] == "") {
//            config.func_do_toast(
//                languages.skeleton_language_objects[config.app_language]
//                ['product_not_set_kindly_restock_product'],
//                Colors.red);
//          } else if (get_product_value(
//              document['id'], 'productLogCurrentStock') ==
//              "0") {
//            config.func_do_toast(
//                languages.skeleton_language_objects[config.app_language]
//                ['product_not_set_kindly_restock_product'],
//                Colors.red);
//          } else {
//            int list_position = cart_list_ids.indexOf(document['id']);
//            print(document.toString());
//            if (cart_list_ids.isEmpty) {
//              setState(() {
//                cart_list_ids.add(document['id']);
//                cart_list_name.add(document['productName']);
//                cart_list_count.add(1);
//                cart_list_value.add(get_product_value(
//                    document['id'], 'productLogBuyingPrice'));
//                cart_list_stock.add(get_product_value(
//                    document['id'], 'productLogCurrentStock'));
//                cart_list_tax.add(config.get_tax_by_id(document['productTax']));
//                product_attributes_list_ids.add(document['productAttribute']);
//                product_log.add(get_product_log(document['id']));
//
//                get_total_amount_value();
//                get_total_items_on_cart();
//                get_total_tax_amount_value();
//              });
//            } else if (!cart_list_ids.contains(document['id'])) {
//              setState(() {
//                cart_list_ids.add(document['id']);
//                cart_list_name.add(document['productName']);
//                cart_list_count.add(1);
//                cart_list_value.add(get_product_value(
//                    document['id'], 'productLogBuyingPrice'));
//                cart_list_stock.add(get_product_value(
//                    document['id'], 'productLogCurrentStock'));
//                cart_list_tax.add(config.get_tax_by_id(document['productTax']));
//                product_attributes_list_ids.add(document['productAttribute']);
//                product_log.add(get_product_log(document['id']));
//                get_total_amount_value();
//                get_total_items_on_cart();
//                get_total_tax_amount_value();
//              });
//            } else {
//              setState(() {
//                cart_list_ids.remove(document['id']);
//                cart_list_name.remove(document['productName']);
//                cart_list_count.removeAt(list_position);
//                cart_list_value.removeAt(list_position);
//                cart_list_stock.removeAt(list_position);
//                cart_list_tax.remove(document['productTax']);
//                product_attributes_list_ids
//                    .remove(document['productAttribute']);
//                product_log.removeAt(list_position);
//                get_total_amount_value();
//                get_total_items_on_cart();
//                get_total_tax_amount_value();
//              });
//            }
//          }
//        },
//        child: Card(
//          color: Colors.white,
//          elevation: 3,
//          child: Container(
//            height: 150,
//            child: Stack(
//              children: <Widget>[
//                Container(
//                  height: 60,
//                  child: Image.network(
//                    document['productImage'][0]['publicUrl'],
//                    fit: BoxFit.fill,
//                  ),
//                ),
//                Container(
//                  color: Colors.black26,
//                  height: 60,
//                  width: 150,
//                ),
//                cart_list_ids.contains(document['id'])
//                    ? Container(
//                    margin: EdgeInsets.only(bottom: 40),
//                    child: Center(
//                      child: Icon(
//                        Icons.check_circle,
//                        color: Colors.grey[200],
//                        size: 35,
//                      ),
//                    ))
//                    : Container(),
//                Container(
//                    margin: EdgeInsets.only(top: 60, left: 10),
//                    child: Text(
//                      document['productName'],
//                      style: TextStyle(
//                          fontFamily: "Roboto",
//                          color: Colors.grey[700],
//                          fontWeight: FontWeight.w500,
//                          fontSize: 12),
//                      maxLines: 2,
//                    )),
//                Container(
//                    margin: EdgeInsets.only(top: 90, left: 10),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Expanded(
//                          flex: 1,
//                          child: Text( "${get_product_value(document['id'],
//                              'productLogBuyingPrice').toString()}" +
//                              "/=",
//                              maxLines: 1,
//                              style: TextStyle(
//                                  fontFamily: "Roboto",
//                                  color: Colors.deepPurple[600],
//                                  fontWeight: FontWeight.w500,
//                                  fontSize: 10)),
//                        ),
//                        Expanded(
//                          flex: 1,
//                          child: Text(
//                              languages.skeleton_language_objects[
//                              config.app_language]['units'] +
//                                  " : " +
//                                  get_product_value(
//                                      document['id'],
//                                      'productLogCurrentStock')
//                                      .toString(),
//                              maxLines: 1,
//                              style: TextStyle(
//                                  fontFamily: "Roboto",
//                                  color: Colors.deepPurple[600],
//                                  fontWeight: FontWeight.w500,
//                                  fontSize: 10)),
//                        ),
//                      ],
//                    )),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  //get amount value
//  get_total_amount_value() {
//    int value = 0;
//    for (int i = 0; i < cart_list_ids.length; i++) {
//      int new_value = cart_list_value[i] * cart_list_count[i];
//      value = value + new_value;
//    }
//    setState(() {
//      total_amount = value;
//    });
//  }
//
//  //gets items on cart
//  get_total_items_on_cart() {
//    int value = 0;
//    for (int i = 0; i < cart_list_ids.length; i++) {
//      value = value + cart_list_count[i];
//    }
//    setState(() {
//      total_items = value;
//    });
//  }
//
//  //get tax amount
//  get_total_tax_amount_value() {
//    double value = 0;
//    for (int i = 0; i < cart_list_ids.length; i++) {
//      value =
//          (cart_list_tax[i] * (cart_list_value[i] * cart_list_count[i])) / 100;
//    }
//    setState(() {
//      total_tax_amount = value;
//    });
//  }
//
//  //gets customer list
//  Widget get_customer_list() => PopupMenuButton(
//    itemBuilder: (context) {
//      var list = List<PopupMenuEntry<Object>>();
//      list.add(
//        PopupMenuItem(
//          child: Text(
//              languages.skeleton_language_objects[config.app_language]
//              ['setting_language']),
//          value: 1,
//        ),
//      );
//      list.add(
//        PopupMenuDivider(
//          height: 10,
//        ),
//      );
//      list.add(
//        CheckedPopupMenuItem(
//          child: Text(
//            "",
//            style: TextStyle(color: Colors.black),
//          ),
//          value: 2,
//          checked: true,
//        ),
//      );
//      return list;
//    },
//    icon: Icon(
//      Icons.settings,
//      size: 50,
//      color: Colors.white,
//    ),
//  );
//
//  // to be implemented later on
//  func_show_online_popupmenu() {}
//
//  //offline bank checkout
//  func_offline_bank_checkout(context) {
//    showDialog(
//      context: context,
//      child: new AlertDialog(
//        title: Text(languages.skeleton_language_objects[config.app_language]
//        ['complete_cash_checkout']),
//        content: Container(
//          height: 200,
//          child: Column(
//            children: <Widget>[
//              Text(languages.skeleton_language_objects[config.app_language]
//              ['you_are_about_to_check_out_with_cash_payment']),
//              SizedBox(height: 10),
//              TextField(
//                maxLines: 1,
//                controller: bankNoteController,
//                keyboardType: TextInputType.text,
//                decoration: InputDecoration(
//                    hintText:
//                    languages.skeleton_language_objects[config.app_language]
//                    ['enter_bank_note'],
//                    hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
//                    labelText:
//                    languages.skeleton_language_objects[config.app_language]
//                    ['bank_note'],
//                    labelStyle:
//                    TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
//              ),
//              SizedBox(height: 15),
//            ],
//          ),
//        ),
//        actions: [
//          new FlatButton(
//            child: Text(languages.skeleton_language_objects[config.app_language]
//            ['cancel']),
//            onPressed: () => Navigator.pop(context),
//          ),
//          new FlatButton(
//            child: Text(
//              languages.skeleton_language_objects[config.app_language]
//              ['complete'],
//              style: TextStyle(color: Colors.teal),
//            ),
//            onPressed: () {
//              if (bankNoteController.text != null &&
//                  bankNoteController.text != "") {
//                func_create_sale('bank');
//                Navigator.pop(context);
//              } else {
//                config.func_do_toast(
//                    languages.skeleton_language_objects[config.app_language]
//                    ['you_need_to_enter_bank_note'],
//                    Colors.red);
//              }
//            },
//          ),
//        ],
//      ),
//    );
//  }
//
//  get_product_value(product_id, value) {
//    String results = "0";
//    for (var x in config.store_product_logs) {
//      if (x['productLogProduct'] == product_id && x["productLogStall"] == stall_firestore_id) {
//        String result_value = x[value].toString();
//        results = result_value;
//      }
//    }
//    print("@@@### : " + results);
//    return results;
//  }
//
//  get_product_log(product_id) {
//    var results;
//    for (var x in config.store_product_logs) {
//      if (x['productLogProduct'] == product_id && x["productLogStall"] == stall_firestore_id) {
//        results = x;
//      }
//    }
//    return results;
//  }
//
//  //function offline/cash checkout
//  func_offline_checkout(context) {
//    showDialog(
//      context: context,
//      child: new AlertDialog(
//        title: Text(languages.skeleton_language_objects[config.app_language]
//        ['complete_cash_checkout']),
//        content: Text(languages.skeleton_language_objects[config.app_language]
//        ['you_are_about_to_check_out_with_cash_payment']),
//        actions: [
//          new FlatButton(
//            child: Text(languages.skeleton_language_objects[config.app_language]
//            ['cancel']),
//            onPressed: () => Navigator.pop(context),
//          ),
//          new FlatButton(
//            child: Text(
//              languages.skeleton_language_objects[config.app_language]
//              ['complete'],
//              style: TextStyle(color: Colors.teal),
//            ),
//            onPressed: () {
//              func_create_sale('paid');
//              Navigator.pop(context);
//            },
//          ),
//        ],
//      ),
//    );
//  }
//
//  //function credit/loan
//  func_credit_checkout(context) {
//    if (customer_data.toString() != "null" && customer_data.toString() != "0") {
//      showDialog(
//        context: context,
//        child: new AlertDialog(
//          title: Text(languages.skeleton_language_objects[config.app_language]
//          ['complete_credit_checkout']),
//          content: Text(languages.skeleton_language_objects[config.app_language]
//          ['you_are_about_to_check_out_with_credit_payment']),
//          actions: [
//            new FlatButton(
//              child: Text(languages
//                  .skeleton_language_objects[config.app_language]['cancel']),
//              onPressed: () => Navigator.pop(context),
//            ),
//            new FlatButton(
//              child: Text(
//                languages.skeleton_language_objects[config.app_language]
//                ['complete'],
//                style: TextStyle(color: Colors.teal),
//              ),
//              onPressed: () {
//                func_create_sale('credit');
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        ),
//      );
//    } else {
//      config.func_do_toast(
//          languages.skeleton_language_objects[config.app_language]
//          ['kindly_choose_a_customer'],
//          Colors.blue);
//    }
//  }
//
//  //this creates a sale on the db
//  func_create_sale(method) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    final CollectionReference purchase_ref =
//    Firestore.instance.collection('/sales');
//
//    var sale_id = randomAlphaNumeric(20);
//    var invoice_no = randomNumeric(5);
//    var salesInvoiceNo = int.parse("${randomNumeric(7)}");
//
//    String items_list = "\n";
//    for (int x = 0; x < cart_list_ids.length; x++) {
//      items_list = items_list +
//          "${(x + 1).toString()} . " +
//          cart_list_name[x].toString().replaceAll("”", "'") +
//          "\t\t\t" +
//          cart_list_count[x].toString() +
//          " X " +
//          cart_list_value[x].toString() +
//          "\n\n";
//    }
//
//    var values = {
//      "createdAt" : FieldValue.serverTimestamp(),
//      "createdBy" : prefs.getString("user_firestore_id"),
//      "giftCard" : "",
//      "id" : sale_id,
//      "importHash" : null,
//      "saleCreditBalance" : "",
//      "saleDevice" : "",
//      "saleNote" : "",
//      "salePaymentDetails" : "",
//      "salePaymentType" : "cash",
//      "saleReturnsProducts" : "",
//      "saleReturnsUnits" : "",
//      "salesCoupon" : "",
//      "salesCustomer" : "",
//      "salesDiscount" : discountController.text == null ? 0 : int.parse(discountController.text),
//      "salesInvoiceNo" : invoice_no,
//      "salesItemLoad" : "",
//      "salesPayload" : "",
//      "salesPaymentMethod" : "",
//      "salesPaymentStatus" : "paid",
//      "salesProducts" : "",
//      "salesProductsCount" : "",
//      "salesProductsValue" : "",
//      "salesReceipt" : "",
//      "salesRegister" : "",
//      "salesReturnReason" : "",
//      "salesStall" : stall_firestore_id,
//      "salesSubTotalAmount" : "",
//      "salesTotalAmount" : total_amount,
//      "salesTotalIUnits" : "",
//      "salesTotalTax" : "",
//      "updatedAt" : FieldValue.serverTimestamp(),
//      "updatedBy" : prefs.getString("user_firestore_id")
//    };
//    await config.create_a_record("sales", values, sale_id);
//    func_credit_products(salesInvoiceNo, items_list);
//  }
//
//  //this func generates a sale payload
//  String func_generate_payload(method) {
//    List product_list = new List();
//    for (int x = 0; x < cart_list_ids.length; x++) {
//      var product_list_item = {
//        '\"name\"': "\"${cart_list_name[x]}\"",
//        '\"id\"': "\"${cart_list_ids[x]}\"",
//        '\"sku\"': '\"${config.get_product_sku_by_id(cart_list_ids[x])}\"',
//        '\"amount\"': cart_list_value[x],
//        '\"currency\"': "\"${config.app_currency}\"",
//        '\"units\"': cart_list_count[x]
//      };
//      product_list.add(product_list_item);
//    }
//    var items = "\"items\": $product_list,";
//    var payments_data = {
//      '\"method\"': '\"$method\"',
//      '\"ref\"':
//      "\"${method != "bank" ? (method + "-" + randomNumeric(6)) : (bankNoteController.text + "-" + randomNumeric(6))}\"",
//      '\"amount\"': total_amount,
//      '\"currency\"': '\"${config.app_currency}\"',
//      '\"paid\"': method == 'credit' ? false : true
//    };
//    var payments = "\"payments\": $payments_data,";
//    var amount_expected = "\"amount_expected\": $total_amount,";
//    var amount_paid = "\"amount_paid\" : $total_amount";
//    var tax = "\"tax\" : $total_tax_amount";
//
//    String payload =
//        '${items.toString() + payments.toString() + amount_expected.toString() + amount_paid.toString() + tax.toString()}';
//    return "{$payload}";
//  }
//
//  //this func credits products count on db
//  func_credit_products(sale_id, items_list) async {
//
//    for (int x = 0; x < cart_list_ids.length; x++) {
//      credit_product_log_stock(x, sale_id);
//    }
//
//    DateTime now = DateTime.now();
//    String formattedDate = DateFormat('kk:mm:ss - EEE d MMM').format(now);
//
//    var data_object = {
//      "cart_list_count": cart_list_count,
//      "total_amount": total_amount,
//      "total_tax_amount": total_tax_amount,
//      "total_items": total_items,
//      "items_list": items_list,
//      "receipt_no": sale_id,
//      "date_time": formattedDate
//    };
//
//    setState(() {
//      receipt_data = data_object;
//      Printing.layoutPdf(
//        onLayout: func_generate_pdf,
//      );
//      cart_list_count.clear();
//      cart_list_ids.clear();
//      cart_list_value.clear();
//      cart_list_name.clear();
//      cart_list_tax.clear();
//      product_log.clear();
//      product_attributes_list_ids.clear();
//      cart_list_stock.clear();
//      total_amount = 0;
//      total_tax_amount = 0;
//      total_items = 0;
//      bankNoteController.clear();
//    });
//  }
//
//  credit_product_log_stock(x, sale_id) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    int sale_units = cart_list_count[x] + (product_log[x]["productLogSoldUnits"] == null ? 0 :  product_log[x]["productLogSoldUnits"]);
//    List sales = product_log[x]["productLogSaleRef"];
//    List sales_list = [];
//    if(sales.isNotEmpty){
//      for(var x in sales){
//        sales_list.add(x);
//      }
//    }
//    sales_list.add(sale_id);
//    int new_units = product_log[x]["productLogCurrentStock"] - cart_list_count[x];
//
//    var values = {
//      "productLogSoldUnits" : sale_units,
//      "productLogCurrentStock" : new_units < 0 ? 0 : new_units,
//      "productLogSaleRef" : sales_list,
//      "updatedAt" : FieldValue.serverTimestamp(),
//      "updatedBy" : prefs.getString("user_firestore_id")
//    };
//    await config.update_a_record("productLogs", values, cart_list_ids[x]);
//  }
//
//}
