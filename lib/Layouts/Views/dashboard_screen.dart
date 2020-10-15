import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Layouts/Views/splash_screen.dart';
import 'package:spree/Utils/back_button_interceptor.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spree/Layouts/Views/home_screen.dart';
import 'package:spree/Layouts/Views/pos_screen.dart';
import 'package:spree/Layouts/Views/reports_screen.dart';
import 'package:spree/Layouts/Views/settings_screen.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class dashboard_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return dashboard_screenState();
  }
}

class dashboard_screenState extends State<dashboard_screen>
    with SingleTickerProviderStateMixin {
  //firestore db dump


  //page key tag
  final Key keyOne = PageStorageKey('pageOne');
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');
  final Key keyFour = PageStorageKey('pageFour');

  int _index = 0;
  TabController _controller;

  //bottom navigation pages
  settings_screen four;
  reports_screen three;
  pos_screen two;
  home_screen one;

  List<Widget> pages;
  Widget currentPage;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    one = home_screen();
    two = pos_screen();
    three = reports_screen();
    four = settings_screen();

     get_store_details();

    get_store_purchases();
    get_store_sales();
    get_store_suppliers();
    get_store_product_logs();
    get_store_brands();
    get_store_categories();
    get_store_inventory();
    get_store_units();
    get_store_tax();
    get_store_customers();
    get_store_stalls();
    get_staffs();
    get_store_devices();
    get_product_count();
    get_product_value();

    pages = [one, two, three, four];

    currentPage = one;

//    BackButtonInterceptor.add(myInterceptor);
    _controller = TabController(vsync: this, length: 4, initialIndex: _index);
  }

  //get device store details
  Future<bool> get_store_details() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("stall_firestore_id") == null){
      final QuerySnapshot result = await Firestore.instance
          .collection('stall')
          .where('id', isEqualTo: prefs.getString("device_deviceStall"))
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if(documents.length == 1){
        prefs.setString("stall_firestore_id", documents[0]["id"]);
        prefs.setString("stall_stallCover", documents[0]["stallCover"][0]["publicUrl"]);
        prefs.setString("stall_stallEmail", documents[0]["stallEmail"]);
        prefs.setString("stall_stallInfo", documents[0]["stallInfo"]);
        prefs.setString("stall_stallIsStatus", documents[0]["stallIsStatus"]);
        prefs.setString("stall_stallLocation", documents[0]["stallLocation"]);
        prefs.setString("stall_stallLoyaltyPointValue", documents[0]["stallLoyaltyPointValue"].toString());
        prefs.setString("stall_stallName", documents[0]["stallName"]);
        prefs.setString("stall_stallPhoneNumber", documents[0]["stallPhoneNumber"]);
        prefs.setString("stall_stallPos", documents[0]["stallPos"]);
        prefs.setString("stall_stallType", documents[0]["stallType"]);
        prefs.setString("stall_createdAt", documents[0]["createdAt"].toString());
      } else if (documents.length > 1){
        config.func_do_toast("Something is wrong", Colors.orange);
      }
        else {
        config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
            ['msg_stall_does_not_exist'],
            Colors.red);
      }
    }
  }

  //logout user if device is not registered.
  do_logout_func() async {
    config.func_do_toast(
        languages.skeleton_language_objects[config.app_language]
            ['device_not_connected_to_any_stall'],
        Colors.red);

    await FirebaseAuth.instance.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_state", "guest_user");
    await prefs.setString("user_id", null);
    await prefs.setString("email", null);

    var route = new MaterialPageRoute(
      builder: (BuildContext context) => new splash_screen(),
    );
    Navigator.of(context).push(route);
  }

  //get product brands
  static Future<bool> get_store_brands() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('brands').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? config.store_brands = documents
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_brands_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get product count
  static Future<bool> get_product_count() async {
    final QuerySnapshot result =
    await Firestore.instance.collection('productCount').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    config.product_count = documents;
    return documents.length == 1;
  }

  //get product value
  static Future<bool> get_product_value() async {
    final QuerySnapshot result =
    await Firestore.instance.collection('productValue').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    config.product_value = documents;
    return documents.length == 1;
  }

  //get devices
  static Future<bool> get_store_devices() async {
    final QuerySnapshot result =
    await Firestore.instance.collection('devices').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? config.store_devices = documents
        : config.func_do_toast(
        languages.skeleton_language_objects[config.app_language]
        ['no_brands_found'],
        Colors.red);

    config.func_do_toast("Done Loading",
        Colors.deepOrange);

    return documents.length == 1;
  }

  //get product categories
  static Future<bool> get_store_categories() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('categories').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? config.store_categories = documents
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_categories_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get product units
  static Future<bool> get_store_units() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('units').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? config.store_units = documents
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_units_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get store customers
  static Future<bool> get_store_customers() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('customers').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? config.store_customers = documents
    : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_customers_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get store supplier
  static Future<bool> get_store_suppliers() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('suppliers').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? config.store_suppliers = documents
    : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_suppliers_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get product tax
  static Future<bool> get_store_tax() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('taxClass').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? config.store_tax = documents
    : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_tax_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get product inventory
  static Future<bool> get_store_inventory() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('products').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ?             config.store_inventory = documents
    : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_products_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get user role
  static Future<bool> get_staffs() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('staff')
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ?       {config.store_staffs = documents}
    : config.func_do_toast(
        languages.skeleton_language_objects[config.app_language]
        ['user_lacking_staff_permissions'],
        Colors.red);
    return documents.length == 1;
  }

  //get store purchase
  static Future<bool> get_store_purchases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('purchases')
        .where("purchasesStallId",
            isEqualTo: prefs.getString("stall_firestore_id"))
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    config.store_purchases = documents;
    return documents.length == 1;
  }

  //get store sales
  static Future<bool> get_store_sales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('sales')
        .where("salesStallId", isEqualTo: prefs.getString("stall_firestore_id"))
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    config.store_sales = documents;
    return documents.length == 1;
  }

  //get store sales
  static Future<bool> get_store_product_logs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance
        .collection('productLogs')
        .where("productLogStall", isEqualTo: prefs.getString("stall_firestore_id"))
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    config.store_product_logs = documents;
    return documents.length == 1;
  }

  //get store stalls
  static Future<bool> get_store_stalls() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('stall').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? config.store_stalls = documents
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_stalls_found'],
            Colors.red);

    return documents.length == 1;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  //Blocks user from closing app
  bool myInterceptor(bool stopDefaultButtonEvent) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (index) => setState(() {
          _index = index;
          _controller.animateTo(_index);
          currentPage = pages[_index];
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(
              Icons.dashboard,
              size: 22,
            ),
            title: Text(
              languages.skeleton_language_objects[config.app_language]
                  ['dashboard'],
              style: new TextStyle(fontFamily: "Roboto", fontSize: 12),
            ),
            activeColor: Colors.deepPurple,
          ),
          BottomNavyBarItem(
              icon: Icon(
                Icons.center_focus_weak,
                size: 22,
              ),
              title: Text(
                languages.skeleton_language_objects[config.app_language]['pos'],
                style: new TextStyle(fontFamily: "Roboto", fontSize: 12),
              ),
              activeColor: Colors.deepPurple),
          BottomNavyBarItem(
            icon: Icon(
              Icons.insert_chart,
              size: 22,
            ),
            title: Text(
              languages.skeleton_language_objects[config.app_language]
                  ['reports'],
              style: new TextStyle(fontFamily: "Roboto", fontSize: 12),
            ),
            activeColor: Colors.deepPurple,
          ),
          BottomNavyBarItem(
              icon: Icon(
                Icons.settings,
                size: 22,
              ),
              title: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['settings'],
                style: new TextStyle(fontFamily: "Roboto", fontSize: 12),
              ),
              activeColor: Colors.deepPurple),
        ],
      ),
    );
  }
}
