import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';

class supplier_details_screen extends StatefulWidget {
  supplier_details_screen(this.staff_id);
  final staff_id;

  @override
  _supplier_details_screenState createState() =>
      _supplier_details_screenState(staff_id);
}

class _supplier_details_screenState extends State<supplier_details_screen> {
  _supplier_details_screenState(this.staff_id);
  final staff_id;

  @override
  void initState() {
    super.initState();
    get_product_details();
  }

  var supplier_purchases_documents;
  var supplier_documents;
  bool loaded = false;

  //check if product exist our db
  Future<bool> get_product_details() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('suppliers')
        .where('id', isEqualTo: staff_id)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 1) {
      setState(() {
        supplier_documents = documents;
        loaded = true;
        get_supplier_purchases_data();
      });
    }

    return documents.length == 1;
  }

  //get staff audit logs
  get_supplier_purchases_data() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('purchases')
        .where('purchaseSupplier', isEqualTo: supplier_documents[0]['id'])
        .limit(10)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      supplier_purchases_documents = documents;
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
          title: Text(
            loaded == true
                ? supplier_documents[0]['supplierBusinessName']
                : languages.skeleton_language_objects[config.app_language]
                    ['loading_suppliers'],
            style: TextStyle(
                fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),
          ),
          actions: <Widget>[
//            IconButton(
//              onPressed: () {
//              },
//              icon: Icon(Icons.mode_edit, color: Colors.grey[800], size: 24,),
//            )
          ],
        ),
        body: loaded == true
            ? Container(
                margin: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          CircleAvatar(
                              radius: 80.0,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: NetworkImage(
                                  supplier_documents[0]['supplierProfile'][0]
                                      ['publicUrl'])),
                          SizedBox(
                            height: 20,
                          ),
                          Text(supplier_documents[0]['supplierNames'],
                              maxLines: 2,
                              style: new TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 24,
                                  color: Colors.grey[800])),
                          SizedBox(
                            height: 10,
                          ),
                          Text(supplier_documents[0]['supplierEmail'],
                              maxLines: 2,
                              style: new TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 16,
                                  color: Colors.grey[500])),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.7,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.message,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.call,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.alternate_email,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      languages.skeleton_language_objects[config.app_language]
                          ['supplier_purchases'],
                      maxLines: 2,
                      style: new TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: Colors.grey[800]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 400,
                        child: supplier_purchases_documents != null
                            ? ListView.builder(
                                itemCount: supplier_purchases_documents.length,
                                itemBuilder: (context, index) => _purchase_tile(
                                    context,
                                    supplier_purchases_documents[index],
                                    index),
                              )
                            : Center(
                                child: SpinKitChasingDots(
                                    color: Colors.deepPurple),
                              ))
                  ],
                ),
              )
            : Center(
                child: SpinKitChasingDots(color: Colors.deepPurple),
              ));
  }

  //purchase list item
  Widget _purchase_tile(context, document, index) {
    return ListTile(
      dense: true,
      enabled: true,
      leading: Icon(Icons.av_timer),
      title: Text(
        '${config.get_product_by_id(document['purchaseProduct'])}',
        style: TextStyle(fontFamily: "Roboto", fontSize: 14),
        maxLines: 2,
      ),
      subtitle: Text(
        'Units : ${document['purchaseUnits']}',
        style: TextStyle(fontFamily: "Roboto", fontSize: 12),
        maxLines: 3,
      ),
      trailing: Text(
        ' T.T ${(document['purchaseTotalAmount'] * document['purchaseUnits']).toString()}',
        style: TextStyle(fontFamily: "Roboto", fontSize: 9),
        maxLines: 3,
      ),
    );
  }
}
