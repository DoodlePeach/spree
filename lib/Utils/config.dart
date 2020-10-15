import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Layouts/Views/device_screen.dart';

class config {
  //chenge to the app url
  static const String app_url = "https://spree-pos.firebaseapp.com";

  //change app name
  static const String app_name = "Spree";

  //change contacts
  static const String app_contacts = "+1 1234 567 890";

  static const String app_po_box = "P.O BOX 12345 - 00100, NAIROBI, KENYA";

  //this holds_the language chosen
  static const String app_language = "english";

  //change currency
  static const String app_currency = "Kes";

  static const String language = "en";

  //change to your site/ terms page
  static const String terms_url =
      'https://codecanyon.net/user/castle_tech_empire';

  //change to your app name
  static const String app_title_name = "Spree";

  static void func_do_toast(msg, color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static var store_sales;
  static var store_purchases;
  static var store_staffs;
  static var store_categories;
  static var store_brands;
  static var store_units;
  static var store_inventory;
  static var store_product_logs;
  static var store_tax;
  static var store_customers;
  static var store_suppliers;
  static var store_stalls;
  static var store_devices;

  static var product_count;
  static var product_value;

  static String permisiions;

  static get_product_values(product_id, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String results = "0";
    for (var x in store_product_logs) {
      if (x['productLogProduct'] == product_id && x["productLogStall"] == prefs.getString("stall_firestore_id")) {
        results = x["$value"].toString();
      }
    }
    print("@@@### : " + results);
    return results;
  }

  static String get_product_by_id(product_id) {
    for (var x in store_inventory) {
      if (x['id'] == product_id) {
        return x['productName'];
      }
    }
  }

  static String get_product_stock_status_by_id(product_id) {
    for (var x in store_inventory) {
      if (x['id'] == product_id) {
        return x['productEnableStock'];
      }
    }
  }

  static String get_product_count_by_id(value) {
    for (var x in product_count) {
      if (x['value'] == value) {
        return x['id'];
      }
    }
    return "";
  }

  static String get_product_value_by_id(value) {
    for (var x in product_value) {
      if (x['value'] == value) {
        return x['id'];
      }
    }
    return "";
  }

  static String get_stall_by_ids(List stall_ids) {
    String name_list = "";
    for (var x in store_stalls) {
      if ( stall_ids.contains(x['id'])){
        name_list = name_list + x['stallName'] + ", ";
      }
    }
    return name_list;
  }

  static get_user_staff_id() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var x in store_staffs) {
      if (prefs.getString("staff_staffUserId") == x['staffUserId']){
        return  x;
      }
    }
  }

  static int get_product_sku_by_id(product_id) {
    for (var x in store_inventory) {
      if (x['id'] == product_id) {
        return x['productSku'];
      }
    }
  }



  static int get_customer_account_balance(customer_id) {
    for (var x in store_customers) {
      if (x['id'] == customer_id) {
        return x['customerAccountBalance'];
      }
    }
  }

  static String get_brand_by_id(brand_id) {
    for (var x in store_brands) {
      if (x['id'] == brand_id) {
        return x['brandTitle'];
      }
    }
  }

  static get_product_log_by_product_id(product_id) {
    for (var x in store_product_logs) {
      if (x['productLogProduct'] == product_id) {
        return x;
      }
    }
  }

  static int get_tax_by_id(tax_id) {
    for (var x in store_tax) {
      if (x['id'] == tax_id) {
        return x['taxClassPercentage'];
      }
    }
  }

  static String get_unit_by_id(unit_id) {
    for (var x in store_units) {
      if (x['id'] == unit_id) {
        return x['unitsTitle'];
      }
    }
  }

  static String get_staff_by_id(staff_id) {
    for (var x in store_staffs) {
      if (x['id'] == staff_id) {
        return x['staffNames'];
      }
    }
  }

  static String get_category_by_ids(category_id) {
    int cat_count = store_categories.length;
    int ids_count = 0;
    String categories = "";

    for (var x in store_categories) {
      if (x['id'].toString().contains(category_id)) {
        categories = categories + ",  " + x['categoryName'];
        ids_count = ids_count + 0;
      }
      if (cat_count == ids_count) {
        return categories;
      }
    }
  }

  static int get_product_units(product_id) {
    for (int i = 0; i < store_purchases; i++) {
      if ((i + 1) == store_purchases.length) {
        print("\n\n\n ${store_purchases[i]['purchasesProductUnits']} \n\n\n");
        return store_purchases[i]['purchasesProductUnits'];
      }
    }
  }

  static int get_product_price(product_id) {
    for (int i = 0; i < store_purchases; i++) {
      if ((i + 1) == store_purchases.length) {
        print("\n\n\n ${store_purchases[i]['purchasesProductUnits']} \n\n\n");
        return store_purchases[i]['purchasesProductUnits'];
      }
    }
  }

  static List get_pos_inventory() {
    List inventory = [];

    for (var x in store_inventory) {
      var product = {
        "id": x['id'],
        "productAlertQuantity": x['productAlertQuantity'],
        "productBrandId": x['productBrandId'],
        "productCategoryId": x['productCategoryId'],
        "productCodeType": x['productCodeType'],
        "productDesc": x['productDesc'],
        "productEnableStock": x['productEnableStock'],
        "productExpiry": x['productExpiry'],
        "productImage": x['productImage'],
        "productName": x['productName'],
        "productPublic": x['productPublic'],
        "productSku": x['productSku'],
        "productTax": x['productTax'],
        "productUnit": x['productUnit'],
        "productCost": get_product_price(x['id']),
        "productUnits": get_product_units(x['id'])
      };
      inventory.add(product);
    }

    return inventory;
  }

  func_inventory_credit() {}

  static void create_a_record(file, values, id) async {
    final CollectionReference collection_ref = Firestore.instance.collection('/$file');
    await collection_ref.document(id).setData(values);
  }

  static void update_a_record(file, values, id) async {
    final CollectionReference collection_ref = Firestore.instance.collection('/$file');
    await collection_ref.document(id).updateData(values);
  }

  static check_permissions(role) {
    var role_list = role.split(new RegExp(r"(?<=[a-z])(?=[A-Z])"));
    String role_names = role_list.toString().replaceAll(",", " ").replaceAll("[", "").replaceAll("]", "");
    var permission  = {
      "can" : false,
      "message" : "You dont have permission for $role_names"
    };
    if(permisiions.contains(role)){
      permission  = {
        "can" : true,
        "message" : ""
      };
    }
    return permission;
  }

}
