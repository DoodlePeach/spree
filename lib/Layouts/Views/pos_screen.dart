import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Layouts/Views/dashboard_screen.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/random_string.dart';
import 'package:pdf/widgets.dart' as pdf;
// import 'package:printing/printing.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:spree/Utils/languages.dart';
import 'package:pdf/pdf.dart';

class pos_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _pos_screenState();
  }
}

class _pos_screenState extends State<pos_screen> {
  Stream<QuerySnapshot> stream;

  int count = 0;
  int total_amount = 0;
  double total_tax_amount = 0;
  int total_items = 0;
  var receipt_data;
  var product_units;
  var store_inventory;
  var gift_card;
  var coupon_code;
  var register_data;

  GlobalKey btnKey = GlobalKey();

  //cart lists
  List<String> cart_list_ids = new List();
  List<String> cart_list_name = new List();
  List<int> cart_list_count = new List();
  List<int> cart_list_value = new List();
  List<int> cart_list_stock = new List();
  List<int> cart_list_tax = new List();
  List product_log = new List();

  List<String> count_list_ids = new List();
  List<String> value_list_ids = new List();

  List<bool> customer_list = new List();

  var customer_data;
  var stall_firestore_id;
  var staff_firestore_id;
  var register_firestore_id;

  //text field controller
  TextEditingController discountController = new TextEditingController();
  TextEditingController bankNoteController = new TextEditingController();
  TextEditingController skuController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController couponController = new TextEditingController();
  TextEditingController registerController = new TextEditingController();

  //register pdf details
  String registerOpenTime,
      registerSales,
      registerItems,
      registerOpeningValue,
      registerClosingValue,
      registerSalveValue,
      registerStall,
      registerStaff,
      registerREF;

  @override
  void initState() {
    super.initState();
    store_inventory = config.store_inventory;
    get_data();
    check_register();
  }

  check_register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("register_firestore_id") == null) {
      var permission = config.check_permissions("registerEditor");
      if (permission["can"] == true) {
        func_register_dialog(context);
      } else {
        config.func_do_toast(permission["message"], Colors.purple);
      }
    } else if (receipt_data == null) {
      get_register_data(prefs.getString("register_firestore_id"));
    } else {}
  }

  get_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stall_firestore_id = prefs.getString("stall_firestore_id");
      staff_firestore_id = prefs.getString("staff_firestore_id");
      register_firestore_id = prefs.getString("register_firestore_id");
    });

    CollectionReference collectionReference =
        Firestore.instance.collection('productLogs');
    setState(() {
      stream = collectionReference
          .where("productLogStall",
              isEqualTo: prefs.getString("stall_firestore_id"))
          .snapshots();
    });
  }

  //this func generates a receipt pdf
  List<int> func_generate_sale_pdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();

    doc.addPage(pdf.Page(build: (pdf.Context context) {
      return pdf.Center(
        child: pdf.Column(children: <pdf.Widget>[
          pdf.Text(config.app_name.toUpperCase(),
              style:
                  pdf.TextStyle(fontSize: 32, fontWeight: pdf.FontWeight.bold)),
          pdf.SizedBox(height: 25),
          pdf.Text(
              " ${languages.skeleton_language_objects[config.app_language]['for_enquiries_call']} : ${config.app_contacts}",
              style: pdf.TextStyle(fontSize: 22)),
          pdf.SizedBox(height: 5),
          pdf.Text("${config.app_po_box}", style: pdf.TextStyle(fontSize: 22)),
          pdf.SizedBox(height: 5),
          pdf.Text(
              "${languages.skeleton_language_objects[config.app_language]['receipt']} # ${receipt_data['receipt_no']}",
              style: pdf.TextStyle(fontSize: 20)),
          pdf.SizedBox(height: 5),
          pdf.Text("${receipt_data['date_time']}",
              style: pdf.TextStyle(fontSize: 20)),
          pdf.SizedBox(height: 30),
          pdf.Container(
            alignment: pdf.Alignment.topLeft,
            child: pdf.Text("${receipt_data['items_list'].toString()}",
                style: pdf.TextStyle(
                    fontSize: 22, fontWeight: pdf.FontWeight.normal),
                textAlign: pdf.TextAlign.left),
          ),
          pdf.SizedBox(height: 30),
          pdf.Container(
              child: pdf.Row(children: <pdf.Widget>[
            pdf.Expanded(
              flex: 1,
              child: pdf.Text(
                  languages.skeleton_language_objects[config.app_language]
                      ['total_amount'],
                  style: pdf.TextStyle(
                      fontSize: 20, fontWeight: pdf.FontWeight.bold),
                  textAlign: pdf.TextAlign.left),
            ),
            pdf.Expanded(
              flex: 1,
              child: pdf.Text("${receipt_data['total_amount']}",
                  style: pdf.TextStyle(fontSize: 20),
                  textAlign: pdf.TextAlign.right),
            ),
          ])),
          pdf.SizedBox(height: 10),
          pdf.Container(
              child: pdf.Row(children: <pdf.Widget>[
            pdf.Expanded(
              flex: 1,
              child: pdf.Text(
                  languages.skeleton_language_objects[config.app_language]
                      ['total_items'],
                  style: pdf.TextStyle(
                      fontSize: 20, fontWeight: pdf.FontWeight.bold),
                  textAlign: pdf.TextAlign.left),
            ),
            pdf.Expanded(
              flex: 1,
              child: pdf.Text("${receipt_data['total_items']}",
                  style: pdf.TextStyle(fontSize: 20),
                  textAlign: pdf.TextAlign.right),
            ),
          ])),
          pdf.SizedBox(height: 10),
          pdf.Container(
              height: 35,
              child: pdf.Row(children: <pdf.Widget>[
                pdf.Expanded(
                  flex: 1,
                  child: pdf.Text(
                      languages.skeleton_language_objects[config.app_language]
                          ['total_tax'],
                      style: pdf.TextStyle(
                          fontSize: 20, fontWeight: pdf.FontWeight.bold),
                      textAlign: pdf.TextAlign.left),
                ),
                pdf.Expanded(
                  flex: 1,
                  child: pdf.Text("${receipt_data['total_tax_amount']}",
                      style: pdf.TextStyle(fontSize: 20),
                      textAlign: pdf.TextAlign.right),
                ),
              ])),
          pdf.SizedBox(height: 35),
          pdf.Text(
              languages.skeleton_language_objects[config.app_language]
                  ['thant_you_and_come_again'],
              style: pdf.TextStyle(fontSize: 24)),
          pdf.Text("FISCAL PRINTER",
              style: pdf.TextStyle(fontSize: 24),
              textAlign: pdf.TextAlign.center),
          pdf.SizedBox(height: 10),
        ]),
      ); // Center
    }));

    return doc.save();
  }

  //this func generates a register pdf
  List<int> func_generate_register_pdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    doc.addPage(pdf.Page(build: (pdf.Context context) {
      return pdf.Column(
          crossAxisAlignment: pdf.CrossAxisAlignment.start,
          mainAxisAlignment: pdf.MainAxisAlignment.start,
          children: <pdf.Widget>[
            pdf.Text(registerStall,
                style: pdf.TextStyle(fontSize: 20),
                textAlign: pdf.TextAlign.center),
            pdf.SizedBox(
              height: 10,
            ),
            pdf.Text(
              "Register Staff : " + registerStaff,
              style: pdf.TextStyle(fontSize: 17),
            ),
            pdf.SizedBox(
              height: 10,
            ),
            pdf.Text(
              "Register REF : " + registerREF,
              style: pdf.TextStyle(fontSize: 17),
            ),
            pdf.SizedBox(
              height: 10,
            ),
            pdf.Text(
              "Register Open Date : " + registerOpenTime,
              style: pdf.TextStyle(fontSize: 17),
            ),
            pdf.SizedBox(
              height: 25,
            ),
            pdf.Text(
              "Total Sales : " + registerSales,
              style: pdf.TextStyle(fontSize: 15),
            ),
            pdf.SizedBox(
              height: 10,
            ),
            pdf.Text("Total SKUS sold : " + registerItems,
                style: pdf.TextStyle(fontSize: 15)),
            pdf.SizedBox(
              height: 10,
            ),
            pdf.Text("Opening Value : " + registerOpeningValue,
                style: pdf.TextStyle(fontSize: 15)),
            pdf.SizedBox(
              height: 10,
            ),
            pdf.Text("Closing Value : " + registerClosingValue,
                style: pdf.TextStyle(fontSize: 15)),
            pdf.SizedBox(
              height: 10,
            ),
            pdf.Text("Sales Value : " + registerSalveValue,
                style: pdf.TextStyle(fontSize: 15)),
            pdf.SizedBox(
              height: 10,
            ),
          ]); // Center
    }));

    return doc.save();
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
                ['make_sale'],
            style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                dashboard_screenState.get_store_product_logs();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {
                if (register_firestore_id != null) {
                  var permission = config.check_permissions("registerViewer");
                  if (permission["can"] == true) {
                    get_all_sales(context);
                  } else {
                    config.func_do_toast(permission["message"], Colors.purple);
                  }
                } else {
                  config.func_do_toast(
                      languages.skeleton_language_objects[config.app_language]
                          ['register_not_set'],
                      Colors.red);
                  var permission = config.check_permissions("registerEditor");
                  if (permission["can"] == true) {
                    func_register_dialog(context);
                  } else {
                    config.func_do_toast(permission["message"], Colors.purple);
                  }
                }
              },
              icon: Icon(
                register_firestore_id != null
                    ? Icons.business_center
                    : Icons.note_add,
                color: Colors.purple[700],
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.camera,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            receipt_data != null
                ? IconButton(
                    onPressed: () {
                      // Printing.layoutPdf(
                      //   onLayout: func_generate_sale_pdf,
                      // );
                    },
                    icon: Icon(
                      Icons.print,
                      color: Colors.green[700],
                      size: 24,
                    ),
                  )
                : Container()
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(Icons.dns, color: Colors.purple),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['total_product_on_cart'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.deepPurple)),
                      subtitle: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['total_items_on_cart'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${cart_list_ids.length}',
                              style: TextStyle(
                                  fontFamily: "Roboto", color: Colors.black)),
                          Text(total_items.toString(),
                              style: TextStyle(
                                  fontFamily: "Roboto", color: Colors.black))
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading:
                          Icon(Icons.fiber_smart_record, color: Colors.purple),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['total_amount_on_cart'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.deepPurple)),
                      subtitle: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['total_tax_amount_on_cart'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${total_amount.toString()}',
                              style: TextStyle(
                                  fontFamily: "Roboto", color: Colors.black)),
                          Text(total_tax_amount.toString(),
                              style: TextStyle(
                                  fontFamily: "Roboto", color: Colors.black))
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Container(
                height: 80.0 * cart_list_ids.length,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart_list_ids.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new ListTile(
                        dense: true,
                        enabled: false,
                        title: Text(
                          '${cart_list_name[index].toString()}',
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.black),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                            '${cart_list_value[index].toString()} X ${cart_list_count[index].toString()} = ${(cart_list_value[index] * cart_list_count[index]).toString()}',
                            style: TextStyle(
                                fontFamily: "Roboto", color: Colors.grey[800])),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  if (cart_list_stock[index] >
                                      cart_list_count[index]) {
                                    int cart_position = index;
                                    int current_value =
                                        cart_list_count[cart_position];
                                    int new_value = current_value + 1;

                                    setState(() {
                                      cart_list_count[cart_position] =
                                          new_value;
                                      get_total_amount_value();
                                      get_total_items_on_cart();
                                      get_total_tax_amount_value();
                                    });
                                  } else {
                                    config.func_do_toast(
                                        languages.skeleton_language_objects[
                                                config.app_language]
                                            ['product_inventory_empty'],
                                        Colors.red);
                                  }
                                },
                                icon: Icon(
                                  Icons.add_box,
                                  color: Colors.green[800],
                                  size: 35,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  int cart_position = index;
                                  int current_value =
                                      cart_list_count[cart_position];

                                  if (current_value == 1) {
                                    setState(() {
                                      cart_list_ids.removeAt(cart_position);
                                      cart_list_name.removeAt(cart_position);
                                      cart_list_count.removeAt(cart_position);
                                      cart_list_value.removeAt(cart_position);
                                      cart_list_stock.removeAt(cart_position);
                                      cart_list_tax.removeAt(cart_position);
                                      product_log.removeAt(cart_position);

                                      get_total_amount_value();
                                      get_total_items_on_cart();
                                      get_total_tax_amount_value();
                                    });
                                    config.func_do_toast(
                                        languages.skeleton_language_objects[
                                                config.app_language]
                                            ['msg_item_removed'],
                                        Colors.red);
                                  } else {
                                    int new_value = current_value - 1;

                                    setState(() {
                                      cart_list_count[cart_position] =
                                          new_value;
                                      get_total_amount_value();
                                      get_total_items_on_cart();
                                      get_total_tax_amount_value();
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.indeterminate_check_box,
                                  color: Colors.red[800],
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: PopupMenuButton(
                            itemBuilder: (context) {
                              var list = List<PopupMenuEntry<Object>>();
                              list.add(
                                PopupMenuItem(
                                  child: Text(
                                    languages.skeleton_language_objects[
                                        config.app_language]['choose_customer'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: 0,
                                ),
                              );
                              list.add(
                                PopupMenuDivider(
                                  height: 10,
                                ),
                              );
                              for (var x in config.store_customers) {
                                customer_list.add(false);
                                list.add(
                                  CheckedPopupMenuItem(
                                    child: Text(
                                      "${x['customerNames']}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    value: x,
                                    checked: false,
                                  ),
                                );
                              }

                              return list;
                            },
                            onSelected: (value) {
                              setState(() {
                                customer_data = value;
                              });
                            },
                            icon: Icon(
                              Icons.person_outline,
                              size: 26,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: PopupMenuButton(
                            itemBuilder: (context) {
                              var list = List<PopupMenuEntry<Object>>();
                              list.add(
                                PopupMenuItem(
                                  child: Text(
                                    languages.skeleton_language_objects[
                                        config.app_language]['enter_discount'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: 0,
                                ),
                              );
                              list.add(
                                PopupMenuDivider(
                                  height: 20,
                                ),
                              );
                              list.add(
                                CheckedPopupMenuItem(
                                  child: TextField(
                                    maxLines: 1,
                                    controller: discountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText:
                                            languages.skeleton_language_objects[
                                                    config.app_language]
                                                ['enter_sale_discount'],
                                        hintStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Roboto"),
                                        labelText:
                                            languages.skeleton_language_objects[
                                                    config.app_language]
                                                ['sale_discount'],
                                        labelStyle: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: "Roboto")),
                                  ),
                                  value:
                                      "${discountController.text.length > 1 ? discountController.text : 0} ",
                                  checked: false,
                                ),
                              );
                              list.add(
                                PopupMenuDivider(
                                  height: 20,
                                ),
                              );
                              return list;
                            },
                            onSelected: (value) {
                              setState(() {
                                customer_data = value;
                              });
                            },
                            icon: Icon(
                              Icons.donut_large,
                              size: 26,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 240,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  func_offline_checkout(context);
                                },
                                child: Container(
                                  height: 75,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: ListTile(
                                      dense: true,
                                      enabled: false,
                                      title: Text(
                                          languages.skeleton_language_objects[
                                              config.app_language]['cash'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black)),
                                      subtitle: Text(
                                          languages.skeleton_language_objects[
                                              config.app_language]['cash'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.grey[800])),
                                      trailing: Icon(
                                        Icons.attach_money,
                                        color: Colors.green[800],
                                        size: 25,
                                      ),
                                      onTap: () {
                                        func_offline_checkout(context);
                                      },
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  config.func_do_toast(
                                      languages.skeleton_language_objects[
                                              config.app_language]
                                          ['online_payments_comming_soon'],
                                      Colors.blue);
//                                  func_show_online_popupmenu();
                                },
                                child: Container(
                                  height: 75,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: ListTile(
                                      dense: true,
                                      enabled: false,
                                      title: Text(
                                          languages.skeleton_language_objects[
                                              config.app_language]['online'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black)),
                                      subtitle: Text('Pay Online',
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.grey[800])),
                                      trailing: Icon(
                                        Icons.network_check,
                                        color: Colors.green[800],
                                        size: 25,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  height: 75,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: ListTile(
                                      dense: true,
                                      enabled: false,
                                      title: Text(
                                          languages.skeleton_language_objects[
                                                  config.app_language]
                                              ['customer_wallet'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black)),
                                      subtitle: Text(
                                          languages.skeleton_language_objects[
                                                  config.app_language]
                                              ['customer_checkout'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.grey[800])),
                                      trailing: Icon(
                                        Icons.person_pin,
                                        color: Colors.green[800],
                                        size: 25,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  func_credit_checkout(context);
                                  if ((customer_data[
                                                  "customerAccountBalance"] ==
                                              null
                                          ? 0
                                          : customer_data[
                                              "customerAccountBalance"]) <
                                      total_amount) {
                                    config.func_do_toast(
                                        languages.skeleton_language_objects[
                                                    config.app_language][
                                                'customer_order_limit_is_below'] +
                                            ' $total_amount',
                                        Colors.yellow);
                                  }
                                },
                              )),
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  func_offline_bank_checkout(context);
                                },
                                child: Container(
                                  height: 75,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: ListTile(
                                      dense: true,
                                      enabled: false,
                                      title: Text(
                                          languages.skeleton_language_objects[
                                              config.app_language]['bank'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black)),
                                      subtitle: Text(
                                          languages.skeleton_language_objects[
                                                  config.app_language]
                                              ['pay_by_bank'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.grey[800])),
                                      trailing: Icon(
                                        Icons.swap_vert,
                                        color: Colors.green[800],
                                        size: 25,
                                      ),
                                      onTap: () {
//                                      offline_check_out();
                                      },
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  if (total_amount != 0) {
                                    func_coupon_checkout(context);
                                  } else {
                                    config.func_do_toast(
                                        languages.skeleton_language_objects[
                                                config.app_language]
                                            ['cart_is_empty'],
                                        Colors.red);
                                  }
                                },
                                child: Container(
                                  height: 75,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: ListTile(
                                      dense: true,
                                      enabled: false,
                                      title: Text(
                                          languages.skeleton_language_objects[
                                              config.app_language]['coupon'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black)),
                                      subtitle: Text(
                                          languages.skeleton_language_objects[
                                              config.app_language]['coupon'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.grey[800])),
                                      trailing: Icon(
                                        Icons.confirmation_number,
                                        color: Colors.green[800],
                                        size: 25,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  if (customer_data != null) {
                                    func_gift_card_checkout(context);
                                  } else {
                                    config.func_do_toast(
                                        languages.skeleton_language_objects[
                                                config.app_language]
                                            ['you_need_to_choose_a_customer'],
                                        Colors.red);
                                  }
                                },
                                child: Container(
                                  height: 75,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: ListTile(
                                      dense: true,
                                      enabled: false,
                                      title: Text(
                                          languages.skeleton_language_objects[
                                              config.app_language]['gift_card'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.black)),
                                      subtitle: Text(
                                          languages.skeleton_language_objects[
                                              config.app_language]['gift_card'],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              color: Colors.grey[800])),
                                      trailing: Icon(
                                        Icons.card_membership,
                                        color: Colors.green[800],
                                        size: 25,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[300],
                height: 200,
              )
            ],
          ),
        ),
        body: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: SpinKitChasingDots(color: Colors.deepPurple),
                );
              count = snapshot.data.documents.length;
              return new GridView.builder(
                itemCount: snapshot.data.documents.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) => _inventory_tile(
                    context, snapshot.data.documents[index], index),
              );
            }));
  }

  //this list items
  Widget _inventory_tile(context, document, index) {
    return Container(
      margin: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () {
          if (register_firestore_id != null) {
            var permission = config.check_permissions("salesEditor");
            if (permission["can"] == true) {
              if (document['productLogCurrentStock'] > 1) {
                int list_position =
                    cart_list_ids.indexOf(document['productLogProduct']);
                if (cart_list_ids.isEmpty) {
                  setState(() {
                    var tax_value = config.get_tax_by_id(get_product_value(
                        document['productLogProduct'], "productTax"));
                    cart_list_ids.add(document['productLogProduct']);
                    cart_list_name.add(get_product_value(
                        document['productLogProduct'], "productName"));
                    cart_list_count.add(1);
                    cart_list_value.add(document['productLogSellingPrice']);
                    cart_list_stock.add(document['productLogCurrentStock']);
                    cart_list_tax.add(tax_value == null ? 0 : tax_value);
                    product_log.add(document);

                    get_total_amount_value();
                    get_total_items_on_cart();
                    get_total_tax_amount_value();
                  });
                } else if (!cart_list_ids
                    .contains(document['productLogProduct'])) {
                  setState(() {
                    var tax_value = config.get_tax_by_id(get_product_value(
                        document['productLogProduct'], "productTax"));
                    cart_list_ids.add(document['productLogProduct']);
                    cart_list_name.add(get_product_value(
                        document['productLogProduct'], "productName"));
                    cart_list_count.add(1);
                    cart_list_value.add(document['productLogSellingPrice']);
                    cart_list_stock.add(document['productLogCurrentStock']);
                    cart_list_tax.add(tax_value == null ? 0 : tax_value);
                    product_log.add(document);

                    get_total_amount_value();
                    get_total_items_on_cart();
                    get_total_tax_amount_value();
                  });
                } else {
                  setState(() {
                    var tax_value = config.get_tax_by_id(get_product_value(
                        document['productLogProduct'], "productTax"));
                    cart_list_ids.remove(document['productLogProduct']);
                    cart_list_name.remove(get_product_value(
                        document['productLogProduct'], "productName"));
                    cart_list_count.removeAt(list_position);
                    cart_list_value.removeAt(list_position);
                    cart_list_stock.removeAt(list_position);
                    cart_list_tax.remove(tax_value == null ? 0 : tax_value);
                    product_log.removeAt(list_position);

                    get_total_amount_value();
                    get_total_items_on_cart();
                    get_total_tax_amount_value();
                  });
                }
              } else if (get_product_value(
                      document['productLogProduct'], "productEnableStock") !=
                  "enabled") {
                int list_position =
                    cart_list_ids.indexOf(document['productLogProduct']);
                if (cart_list_ids.isEmpty) {
                  setState(() {
                    var tax_value = config.get_tax_by_id(get_product_value(
                        document['productLogProduct'], "productTax"));
                    cart_list_ids.add(document['productLogProduct']);
                    cart_list_name.add(get_product_value(
                        document['productLogProduct'], "productName"));
                    cart_list_count.add(1);
                    cart_list_value.add(document['productLogSellingPrice']);
                    cart_list_stock.add(100000);
                    cart_list_tax.add(tax_value == null ? 0 : tax_value);
                    product_log.add(document);

                    get_total_amount_value();
                    get_total_items_on_cart();
                    get_total_tax_amount_value();
                  });
                } else if (!cart_list_ids
                    .contains(document['productLogProduct'])) {
                  setState(() {
                    var tax_value = config.get_tax_by_id(get_product_value(
                        document['productLogProduct'], "productTax"));
                    cart_list_ids.add(document['productLogProduct']);
                    cart_list_name.add(get_product_value(
                        document['productLogProduct'], "productName"));
                    cart_list_count.add(1);
                    cart_list_value.add(document['productLogSellingPrice']);
                    cart_list_stock.add(100000);
                    cart_list_tax.add(tax_value == null ? 0 : tax_value);
                    product_log.add(document);

                    get_total_amount_value();
                    get_total_items_on_cart();
                    get_total_tax_amount_value();
                  });
                } else {
                  setState(() {
                    var tax_value = config.get_tax_by_id(get_product_value(
                        document['productLogProduct'], "productTax"));
                    cart_list_ids.remove(document['productLogProduct']);
                    cart_list_name.remove(get_product_value(
                        document['productLogProduct'], "productName"));
                    cart_list_count.removeAt(list_position);
                    cart_list_value.removeAt(list_position);
                    cart_list_stock.add(100000);
                    cart_list_tax.remove(tax_value == null ? 0 : tax_value);
                    product_log.removeAt(list_position);

                    get_total_amount_value();
                    get_total_items_on_cart();
                    get_total_tax_amount_value();
                  });
                }
              } else {}
            } else {
              config.func_do_toast(permission["message"], Colors.purple);
            }
          } else {
            config.func_do_toast(
                languages.skeleton_language_objects[config.app_language]
                    ['register_not_set'],
                Colors.red);
          }
        },
        child: Card(
          color: Colors.white,
          elevation: 3,
          child: Container(
            height: 150,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 60,
                  child: Image.network(
                    get_product_value(
                            document['productLogProduct'], "productImage")[0]
                        ['publicUrl'],
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  color: Colors.black26,
                  height: 60,
                  width: 150,
                ),
                cart_list_ids.contains(document['productLogProduct'])
                    ? Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: Center(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.grey[200],
                            size: 35,
                          ),
                        ))
                    : Container(),
                Container(
                    margin: EdgeInsets.only(top: 60, left: 10),
                    child: Text(
                      get_product_value(
                          document['productLogProduct'], "productName"),
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                      maxLines: 2,
                    )),
                Container(
                    margin: EdgeInsets.only(top: 80, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                              "${document['productLogSellingPrice'].toString()}" +
                                  "/=",
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.deepPurple[600],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10)),
                        ),
                        get_product_value(document['productLogProduct'],
                                    "productEnableStock") ==
                                "enabled"
                            ? Expanded(
                                flex: 1,
                                child: Text(
                                    languages.skeleton_language_objects[
                                            config.app_language]['units'] +
                                        " : " +
                                        document['productLogCurrentStock']
                                            .toString()
                                            .toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        color: Colors.deepPurple[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10)),
                              )
                            : Container(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  get_product_value(product_id, value) {
    var results;
    for (var x in store_inventory) {
      if (x['id'] == product_id) {
        results = x[value];
      }
    }
    return results;
  }

  //get amount value
  get_total_amount_value() {
    int value = 0;
    for (int i = 0; i < cart_list_ids.length; i++) {
      int new_value = cart_list_value[i] * cart_list_count[i];
      value = value + new_value;
    }
    setState(() {
      total_amount = value;
    });
  }

  //gets items on cart
  get_total_items_on_cart() {
    int value = 0;
    for (int i = 0; i < cart_list_ids.length; i++) {
      value = value + cart_list_count[i];
    }
    setState(() {
      total_items = value;
    });
  }

  //get tax amount
  get_total_tax_amount_value() {
    double value = 0;
    for (int i = 0; i < cart_list_ids.length; i++) {
      value = ((cart_list_tax[i] == null ? 0 : cart_list_tax[i]) *
              (cart_list_value[i] * cart_list_count[i])) /
          100;
    }
    setState(() {
      total_tax_amount = value;
    });
  }

  //to be implemented in the future
  get_stripe_payment() {}

  //function offline/cash checkout
  func_offline_checkout(context) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
            ['complete_cash_checkout']),
        content: Text(languages.skeleton_language_objects[config.app_language]
            ['you_are_about_to_check_out_with_cash_payment']),
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
              func_create_sale('paid', "cash_checkout");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //function credit/loan
  func_credit_checkout(context) {
    if (customer_data != null) {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: Text(languages.skeleton_language_objects[config.app_language]
              ['complete_credit_checkout']),
          content: Text(languages.skeleton_language_objects[config.app_language]
              ['you_are_about_to_check_out_with_credit_payment']),
          actions: [
            new FlatButton(
              child: Text(languages
                  .skeleton_language_objects[config.app_language]['cancel']),
              onPressed: () => Navigator.pop(context),
            ),
            new FlatButton(
              child: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['complete'],
                style: TextStyle(color: Colors.teal),
              ),
              onPressed: () {
                func_create_sale('credit', "customer_checkout");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      config.func_do_toast(
          languages.skeleton_language_objects[config.app_language]
              ['kindly_choose_a_customer'],
          Colors.blue);
    }
  }

  //create register
  func_register_dialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
            ['create_register']),
        content: Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Text(languages.skeleton_language_objects[config.app_language]
                  ['confirm_create_register']),
              SizedBox(height: 10),
              TextField(
                maxLines: 1,
                controller: registerController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText:
                        languages.skeleton_language_objects[config.app_language]
                            ['enter_opening_amount'],
                    hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText:
                        languages.skeleton_language_objects[config.app_language]
                            ['enter_opening_amount'],
                    labelStyle:
                        TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
        actions: [
          new FlatButton(
            child: Text(
              languages.skeleton_language_objects[config.app_language]
                  ['complete'],
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              if (registerController.text.isNotEmpty) {
                create_stall_register(context);
              } else {
                config.func_do_toast(
                    languages.skeleton_language_objects[config.app_language]
                        ['you_need_to_enter_ammount'],
                    Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }

  //offline bank checkout
  func_offline_bank_checkout(context) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
            ['complete_cash_checkout']),
        content: Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Text(languages.skeleton_language_objects[config.app_language]
                  ['you_are_about_to_check_out_with_cash_payment']),
              SizedBox(height: 10),
              TextField(
                maxLines: 1,
                controller: bankNoteController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText:
                        languages.skeleton_language_objects[config.app_language]
                            ['enter_bank_note'],
                    hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText:
                        languages.skeleton_language_objects[config.app_language]
                            ['bank_note'],
                    labelStyle:
                        TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
              ),
              SizedBox(height: 15),
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
              if (bankNoteController.text != null &&
                  bankNoteController.text != "") {
                func_create_sale('paid', "bank_checkout");
                Navigator.pop(context);
              } else {
                config.func_do_toast(
                    languages.skeleton_language_objects[config.app_language]
                        ['you_need_to_enter_bank_note'],
                    Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }

  //gift card checkout
  func_gift_card_checkout(context) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
            ['complete_with_card_checkout']),
        content: Container(
          height: 200,
          child: ListView(
            children: <Widget>[
              Text(
                  "${gift_card == null ? "0.0 Gift card value" : gift_card["giftCardAmmount"].toString() + " Gift card value"}"),
              SizedBox(height: 10),
              Text(
                  "${gift_card == null ? "$total_amount Amount Remaining" : gift_card["giftCardAmmount"] > total_amount ? "Amount Settled" : "${total_amount - gift_card["giftCardAmmount"]} Amount Remaining"}"),
              SizedBox(height: 10),
              gift_card != null
                  ? gift_card["giftCardAmmount"] > total_amount
                      ? TextField(
                          maxLines: 1,
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: languages.skeleton_language_objects[
                                  config.app_language]['enter_amount_balance'],
                              hintStyle: TextStyle(
                                  fontSize: 14.0, fontFamily: "Roboto"),
                              labelText: languages.skeleton_language_objects[
                                  config.app_language]['amount_balance'],
                              labelStyle: TextStyle(
                                  fontSize: 12.0, fontFamily: "Roboto")),
                        )
                      : Container()
                  : Container(),
              SizedBox(height: 15),
            ],
          ),
        ),
        actions: [
          gift_card != null
              ? new FlatButton(
                  child: Text(
                      languages.skeleton_language_objects[config.app_language]
                          ['cancel_coupon']),
                  onPressed: () {
                    setState(() {
                      gift_card = null;
                    });
                    Navigator.pop(context);
                  },
                )
              : Container(),
          new FlatButton(
            child: Text(languages.skeleton_language_objects[config.app_language]
                ['cancel']),
            onPressed: () => Navigator.pop(context),
          ),
          new FlatButton(
            child: Text(
              gift_card == null
                  ? languages.skeleton_language_objects[config.app_language]
                      ['check_gift_card']
                  : languages.skeleton_language_objects[config.app_language]
                      ['complete'],
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              if (gift_card != null) {
                if ((gift_card["giftCardAmmount"] +
                        (amountController.text.isNotEmpty
                            ? int.parse(amountController.text)
                            : 0)) >=
                    total_amount) {
                  func_create_sale('paid', "gift_card_checkout");
                  Navigator.pop(context);
                } else {
                  config.func_do_toast(
                      languages.skeleton_language_objects[config.app_language]
                          ['total_paid_is_less_than_total_amount'],
                      Colors.red);
                }
              } else {
                get_gift_card();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  //couponcheckout
  func_coupon_checkout(context) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
            ['complete_with_coupon']),
        content: Container(
          height: 200,
          child: ListView(
            children: <Widget>[
              Text(languages.skeleton_language_objects[config.app_language]
                  ['confirm_coupon_checkout']),
              SizedBox(height: 10),
              Text(
                  "${coupon_code != null ? (coupon_code["couponType"] == "Percentage" ? coupon_code["couponValue"] / 100 * total_amount : coupon_code["couponValue"]) : "0.0"} Coupon value"),
              SizedBox(height: 10),
              Text(
                  "${coupon_code != null ? total_amount - (coupon_code["couponType"] == "Percentage" ? coupon_code["couponValue"] / 100 * total_amount : coupon_code["couponValue"]) : "0.0"} Total Balance"),
              SizedBox(height: 10),
              coupon_code == null
                  ? TextField(
                      maxLines: 1,
                      controller: couponController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: languages.skeleton_language_objects[
                              config.app_language]['enter_coupon_code'],
                          hintStyle:
                              TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                          labelText: languages.skeleton_language_objects[
                              config.app_language]['coupon_code'],
                          labelStyle:
                              TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
                    )
                  : Container(),
              SizedBox(height: 10),
              coupon_code != null
                  ? TextField(
                      maxLines: 1,
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: languages.skeleton_language_objects[
                              config.app_language]['enter_amount_balance'],
                          hintStyle:
                              TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                          labelText: languages.skeleton_language_objects[
                              config.app_language]['amount_balance'],
                          labelStyle:
                              TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
                    )
                  : Container(),
              SizedBox(height: 15),
            ],
          ),
        ),
        actions: [
          coupon_code != null
              ? new FlatButton(
                  child: Text(
                      languages.skeleton_language_objects[config.app_language]
                          ['cancel_coupon']),
                  onPressed: () {
                    setState(() {
                      coupon_code = null;
                    });
                    Navigator.pop(context);
                  },
                )
              : Container(),
          new FlatButton(
            child: Text(languages.skeleton_language_objects[config.app_language]
                ['cancel']),
            onPressed: () => Navigator.pop(context),
          ),
          new FlatButton(
            child: Text(
              coupon_code == null
                  ? languages.skeleton_language_objects[config.app_language]
                      ['check_coupon_code']
                  : languages.skeleton_language_objects[config.app_language]
                      ['complete'],
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              if (coupon_code != null) {
                String type = coupon_code["couponType"];
                if ((type == "Percentage"
                            ? coupon_code["couponValue"] / 100 * total_amount
                            : coupon_code["couponValue"]) +
                        int.parse(amountController.text) >=
                    total_amount) {
                  func_create_sale('paid', "coupon_checkout");
                  Navigator.pop(context);
                } else {
                  config.func_do_toast(
                      languages.skeleton_language_objects[config.app_language]
                          ['total_paid_is_less_than_total_amount'],
                      Colors.red);
                }
              } else {
                get_coupon();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  //this creates a sale on the db
  func_create_sale(method, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss - EEE d MMM').format(now);

    var sale_id = randomAlphaNumeric(20);
    var invoice_no = randomNumeric(5);

    String items_list = create_items_list();
    var sale_item_load = generate_sale_item_load();

    for (int x = 0; x < cart_list_ids.length; x++) {
      create_product_value(cart_list_value[x]);
      create_product_count(cart_list_count[x]);
    }

    int discount = discountController.text.isEmpty
        ? 0
        : int.parse(discountController.text);

    var sale_payload = {
      "invoice": invoice_no,
      "method": method,
      "cart_total_amount": total_amount,
      "note": bankNoteController.text,
      "amount_paid": method == "credit" ? 0 : total_amount
    };

    var payment_details = {
      "payment_gift_card": gift_card,
      "payment_coupon": coupon_code,
      "payment_amount": amountController.text
    };

    int customer_credit = method == "credit"
        ? (customer_data["customerCreditBalance"] == null
                ? 0
                : customer_data["customerCreditBalance"]) -
            total_amount
        : 0;
    await method == "credit"
        ? credit_customer(customer_credit)
        : type == "gift_card_checkout"
            ? update_gift_card()
            : type == "coupon_checkout"
                ? update_coupon(sale_id)
                : "";

    prefs.getString("stall_stallLoyaltyPointValue") != null &&
            customer_data != null
        ? update_customer_loyalty_points()
        : "";

    var values = {
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": prefs.getString("user_firestore_id"),
      "giftCard": gift_card == null ? null : gift_card["id"],
      "id": sale_id,
      "importHash": null,
      "saleCreditBalance": customer_credit,
      "saleDevice": prefs.getString("device_firestore_id"),
      "saleNote": null,
      "salePaymentDetails": payment_details.toString(),
      "salePaymentType": type,
      "saleReturnsProducts": 0,
      "saleReturnsUnits": 0,
      "salesCoupon": coupon_code == null ? null : coupon_code["id"],
      "salesCustomer": "${customer_data == null ? "" : customer_data["id"]}",
      "salesDiscount": discount,
      "salesInvoiceNo": invoice_no,
      "salesItemLoad": sale_item_load,
      "salesPayload": sale_payload,
      "salesPaymentMethod": "${method == "credit" ? "credit" : "cash"}",
      "salesPaymentStatus": method,
      "salesProducts": cart_list_ids,
      "salesProductsCount": count_list_ids,
      "salesProductsValue": value_list_ids,
      "salesReceipt": items_list,
      "salesRegister": prefs.getString("register_firestore_id"),
      "salesReturnReason": null,
      "salesStall": stall_firestore_id,
      "salesSubTotalAmount": total_amount - total_tax_amount - discount,
      "salesTotalAmount": total_amount,
      "salesTotalIUnits": total_items,
      "salesTotalTax": total_tax_amount,
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.create_a_record("sales", values, sale_id);
    await func_credit_products(sale_id, items_list);

    var data_object = {
      "cart_list_count": cart_list_count,
      "total_amount": total_amount,
      "total_tax_amount": total_tax_amount,
      "total_items": total_items,
      "items_list": items_list,
      "receipt_no": sale_id,
      "date_time": formattedDate
    };

    setState(() {
      receipt_data = data_object;
      // Printing.layoutPdf(
      //   onLayout: func_generate_sale_pdf,
      // );
      cart_list_count.clear();
      cart_list_ids.clear();
      cart_list_value.clear();
      cart_list_name.clear();
      cart_list_tax.clear();
      product_log.clear();
      cart_list_stock.clear();
      total_amount = 0;
      total_tax_amount = 0;
      total_items = 0;
      bankNoteController.clear();
      amountController.clear();
      discountController.clear();
      couponController.clear();
      gift_card = null;
      coupon_code = null;
    });
  }

  String create_items_list() {
    String items_list = "\n";
    for (int x = 0; x < cart_list_ids.length; x++) {
      items_list = items_list +
          "${(x + 1).toString()} . " +
          cart_list_name[x].toString().replaceAll("”", "'") +
          "\t\t\t" +
          cart_list_count[x].toString() +
          " X " +
          cart_list_value[x].toString() +
          "\n\n";
    }
    return items_list;
  }

  generate_sale_item_load() {
    List sale_item_load = [];
    for (int x = 0; x < cart_list_ids.length; x++) {
      sale_item_load.add({
        'id': cart_list_ids[x],
        'name': cart_list_name[x],
        'count': cart_list_count[x],
        'value': cart_list_value[x],
        'tax': cart_list_tax[x]
      });
    }
    return sale_item_load;
  }

  //this func credits products count on db
  func_credit_products(sale_id, items_list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int x = 0; x < cart_list_ids.length; x++) {
      int sale_units = cart_list_count[x] +
          (product_log[x]["productLogSoldUnits"] == null
              ? 0
              : product_log[x]["productLogSoldUnits"]);
      List sales = product_log[x]["productLogSaleRef"];
      List sales_list = [];
      if (sales.isNotEmpty) {
        for (var x in sales) {
          sales_list.add(x);
        }
      }
      sales_list.add(sale_id);
      if (config.get_product_stock_status_by_id(
              product_log[x]["productLogProduct"]) ==
          "enabled") {
        int new_units =
            product_log[x]["productLogCurrentStock"] - cart_list_count[x];

        var values = {
          "productLogSoldUnits": sale_units,
          "productLogCurrentStock": new_units < 0 ? 0 : new_units,
          "productLogSaleRef": sales_list,
          "updatedAt": FieldValue.serverTimestamp(),
          "updatedBy": prefs.getString("user_firestore_id")
        };
        await config.update_a_record(
            "productLogs", values, product_log[x]["id"]);
      } else {
        var values = {
          "productLogSoldUnits": sale_units,
          "productLogSaleRef": sales_list,
          "updatedAt": FieldValue.serverTimestamp(),
          "updatedBy": prefs.getString("user_firestore_id")
        };
        await config.update_a_record(
            "productLogs", values, product_log[x]["id"]);
      }
    }
  }

  create_product_value(value) async {
    String results = config.get_product_count_by_id(value);
    if (results != "") {
      value_list_ids.add(results);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var value_id = randomAlphaNumeric(20);
      var values = {
        "createdAt": FieldValue.serverTimestamp(),
        "createdBy": prefs.getString("user_firestore_id"),
        "id": value_id,
        "importHash": null,
        "updatedAt": FieldValue.serverTimestamp(),
        "updatedBy": prefs.getString("user_firestore_id"),
        "value": value
      };
      value_list_ids.add(value_id);
      await config.create_a_record("productValue", values, value_id);
    }
  }

  create_product_count(value) async {
    String results = config.get_product_value_by_id(value);
    if (results != "") {
      value_list_ids.add(results);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var count_id = randomAlphaNumeric(20);
      var values = {
        "createdAt": FieldValue.serverTimestamp(),
        "createdBy": prefs.getString("user_firestore_id"),
        "id": count_id,
        "importHash": null,
        "updatedAt": FieldValue.serverTimestamp(),
        "updatedBy": prefs.getString("user_firestore_id"),
        "value": value
      };
      count_list_ids.add(count_id);
      await config.create_a_record("productCount", values, count_id);
    }
  }

  get_gift_card() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('giftCard')
        .where('giftCardCustomer', isEqualTo: customer_data["customerUserId"])
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      config.func_do_toast(
          languages.skeleton_language_objects[config.app_language]
              ['gift_card_missing'],
          Colors.red);
    } else {
      config.func_do_toast(
          languages.skeleton_language_objects[config.app_language]
              ['gift_card_found'],
          Colors.green);
      setState(() {
        gift_card = documents[0];
      });
    }
  }

  get_coupon() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('coupon')
        .where("couponCode", isEqualTo: couponController.text)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      config.func_do_toast(
          languages.skeleton_language_objects[config.app_language]
              ['coupon_missing'],
          Colors.red);
    } else {
      if (documents[0]["couponStatus"] == "Active" &&
          documents[0]["couponMaxUse"] > 0) {
        if (documents[0]["couponStall"] != stall_firestore_id) {
          setState(() {
            coupon_code = documents[0];
          });
          config.func_do_toast(
              languages.skeleton_language_objects[config.app_language]
                  ['coupon_found'],
              Colors.green);
        } else {
          config.func_do_toast(
              languages.skeleton_language_objects[config.app_language]
                  ['coupon_not_for_this_stall'],
              Colors.red);
        }
      } else {
        config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['coupon_defective'],
            Colors.red);
      }
    }
  }

  credit_customer(customer_ball) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var values = {
      "customerAccountBalance": customer_ball,
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.update_a_record("customers", values, customer_data["id"]);
    config.func_do_toast("Customer credited successfull", Colors.green);
  }

  update_gift_card() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var values = {
      "giftCardAmmount": total_amount >= gift_card["giftCardAmmount"]
          ? gift_card["giftCardAmmount"]
          : gift_card["giftCardAmmount"] - total_amount,
      "giftCardStatus":
          total_amount >= gift_card["giftCardAmmount"] ? "Used" : "Pending",
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.update_a_record("giftCard", values, gift_card["id"]);
  }

  update_coupon(sale_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int usage_count = (coupon_code["couponUsageCount"] == null
            ? 0
            : coupon_code["couponUsageCount"]) +
        1;

    List coupons = coupon_code["couponSalesUsed"];
    List coupons_list = [];
    if (coupons != []) {
      for (var x in coupons) {
        coupons_list.add(x);
      }
    }
    coupons_list.add(sale_id);

    var values = {
      "couponSalesUsed": coupons_list,
      "couponUsageCount": usage_count,
      "couponStatus":
          usage_count < coupon_code["couponMaxUse"] ? "Active" : "Inactive",
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.update_a_record("coupon", values, coupon_code["id"]);
  }

  update_customer_loyalty_points() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double calculated_points = total_amount /
        int.parse(prefs.getString("stall_stallLoyaltyPointValue"));
    double new_points = (customer_data["customerLoyaltyPoints"] == null
            ? 0
            : customer_data["customerLoyaltyPoints"]) +
        calculated_points;
    var values = {
      "customerLoyaltyPoints": new_points.round(),
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.update_a_record("customers", values, customer_data["id"]);
  }

  update_register_info() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var values = {
      "giftCardAmmount": "",
      "giftCardStatus": "",
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.update_a_record("giftCard", values, gift_card["id"]);
  }

  get_all_sales(context) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('sales')
        .where('salesRegister', isEqualTo: register_firestore_id)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      config.func_do_toast(
          languages.skeleton_language_objects[config.app_language]
              ['no_sales_made'],
          Colors.deepOrange);
    } else {
      int total_sales = 0;
      List registerSaleItems = [];
      List registerSaleRef = [];
      for (var x in documents) {
        total_sales = total_sales + x["salesTotalAmount"];
        List items_list = x["salesProducts"];
        registerSaleItems = registerSaleItems + items_list;
        registerSaleRef.add(x["id"]);
      }
      print("@@@" + registerSaleItems.toString());
      update_register_sales(
          context, total_sales, registerSaleItems, registerSaleRef);
    }
  }

  update_register_sales(
      context, total_sales, registerSaleItems, registerSaleRef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var values = {
      "registerSaleItems": registerSaleItems,
      "registerSaleRef": registerSaleRef,
      "registerSaleValue": total_sales,
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.update_a_record("register", values, register_firestore_id);
    func_show_register_sales(
        context, total_sales, registerSaleItems, registerSaleRef);
  }

  create_stall_register(context) async {
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var register_id = randomAlphaNumeric(20);
    var values = {
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": prefs.getString("user_firestore_id"),
      "id": register_id,
      "importHash": null,
      "registerCloseTime": null,
      "registerClosingValue": null,
      "registerOpenTime": now.toString(),
      "registerOpeningValue": int.parse(registerController.text),
      "registerRef": "${register_id.toString().substring(0, 5)}",
      "registerSaleItems": [],
      "registerSaleRef": [],
      "registerSaleValue": 0,
      "registerStaff": staff_firestore_id,
      "registerStall": stall_firestore_id,
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.create_a_record("register", values, register_id);
    prefs.setString("register_firestore_id", register_id);
    prefs.setString("register_registerOpeningValue", registerController.text);
    register_firestore_id = register_id;
    Navigator.pop(context);
  }

  //function offline/cash checkout
  func_show_register_sales(
      context, total_sales, registerSaleItems, registerSaleRef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text("REF : " + register_data["registerRef"]),
        content: Container(
          height: 250,
          child: ListView(
            children: <Widget>[
              Text(
                "Register Open Date \n" +
                    register_data["registerOpenTime"]
                        .toString()
                        .substring(0, 21),
                style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Total Sales : " + registerSaleRef.length.toString(),
                style: TextStyle(
                    fontFamily: "Roboto",
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Total SKUS sold : " + registerSaleItems.length.toString(),
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 15)),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Opening Value : " +
                      register_data["registerOpeningValue"].toString(),
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 15)),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Closing Value : " +
                      (register_data["registerOpeningValue"] + total_sales)
                          .toString(),
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 15)),
              SizedBox(
                height: 10,
              ),
              Text("Sales Value : " + total_sales.toString(),
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 15)),
              SizedBox(
                height: 10,
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
            child: Text(languages.skeleton_language_objects[config.app_language]
                ['print_register']),
            onPressed: () {
              setState(() {
                registerOpenTime = register_data["registerOpenTime"]
                    .toString()
                    .substring(0, 21);
                registerSales = registerSaleRef.length.toString();
                registerItems = registerSaleItems.length.toString();
                registerOpeningValue =
                    register_data["registerOpeningValue"].toString();
                registerClosingValue =
                    (register_data["registerOpeningValue"] + total_sales)
                        .toString();
                registerSalveValue = total_sales.toString();
                registerStall = prefs.getString("stall_stallName");
                registerStaff = prefs.getString("user_fullName");
                registerREF = register_data["registerRef"];
                // Printing.layoutPdf(
                //   onLayout: func_generate_register_pdf,
                // );
              });
              Navigator.pop(context);
            },
          ),
          new FlatButton(
            child: Text(
              languages.skeleton_language_objects[config.app_language]
                  ['close_register'],
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              close_register(total_sales);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  get_register_data(register_id) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('register')
        .where("registerCloseTime", isEqualTo: null)
        .where('id', isEqualTo: register_id)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      config.func_do_toast(
          languages.skeleton_language_objects[config.app_language]
              ['register_not_found'],
          Colors.red);
      func_register_dialog(context);
    } else {
      setState(() {
        register_data = documents[0];
      });
    }
  }

  close_register(total_sales) async {
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int closing_value = register_data["registerOpeningValue"] + total_sales;
    var values = {
      "registerCloseTime": now.toIso8601String(),
      "registerClosingValue": closing_value,
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": prefs.getString("user_firestore_id")
    };
    await config.update_a_record("register", values, register_firestore_id);
    prefs.setString("register_firestore_id", null);
    prefs.setString("register_registerOpeningValue", null);
    setState(() {
      register_firestore_id = null;
      register_data = null;
    });
  }
}
