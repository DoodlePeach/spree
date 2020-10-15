import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

import 'package:pdf/widgets.dart' as pdf;

class sales_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _sales_screenState();
  }
}

class _sales_screenState extends State<sales_screen> {
  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  var sale_data_object;

  //query data from firebase current limit is 100
  get_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference collectionReference =
        Firestore.instance.collection('sales');
    setState(() {
      stream = collectionReference
          .where('salesStall', isEqualTo: prefs.getString("stall_firestore_id"))
          .snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(
            languages.skeleton_language_objects[config.app_language]
                ['stall_sales'],
            style: TextStyle(
                fontFamily: "Roboto", fontSize: 18, color: Colors.grey[800]),
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
              return new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _sales_tile(context, snapshot.data.documents[index], index),
              );
            }));
  }

  //sales list item
  Widget _sales_tile(context, document, index) {
    return ListTile(
      key: ValueKey(document.documentID),
      title: Text(document['salesInvoiceNo'].toString(),
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text(
          "${languages.skeleton_language_objects[config.app_language]['receipt_amount']} : " +
              document['salesTotalAmount'].toString(),
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      trailing: Icon(
          document["salesPaymentStatus"] == "paid"
              ? Icons.check_circle
              : Icons.remove_circle_outline,
          color: Colors.green[800],
          size: 20),
      leading: Container(
        width: 30,
        child: Center(
          child: Icon(FontAwesomeIcons.receipt),
        ),
      ),
      onTap: () {
        setState(() {
          sale_data_object = document;
        });
        // prt.Printing.layoutPdf(
        //   onLayout: func_generate_pdf,
        // );
      },
    );
  }

  //func organize cart receipt items
  func_organize_items(items) async {
    String items_list = "\n";
    for (int x = 0; x < items.length; x++) {
      items_list = items_list +
          items[x]['name'].toString() +
          "\t\t\t" +
          items[x]['units'].toString() +
          " X " +
          items[x]['amount'].toString() +
          "\n";
      print("${(x).toString()}" + " ... " + items_list);
    }
    return items_list;
  }

  //this generates a pdf to be printed
  List<int> func_generate_pdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    var items = sale_data_object['salesItemLoad'];

    String items_list = "\n";
    for (int x = 0; x < items.length; x++) {
      items_list = items_list +
          "${(x + 1).toString()} . " +
          items[x]['name'].toString() +
          "\t\t\t" +
          items[x]['count'].toString() +
          " X " +
          items[x]['value'].toString() +
          "\n\n";
    }

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
              "${languages.skeleton_language_objects[config.app_language]['receipt']} # ${sale_data_object['salesInvoiceNo']}",
              style: pdf.TextStyle(fontSize: 20)),
          pdf.SizedBox(height: 5),
          pdf.Text(
              "${sale_data_object['createdAt'].toDate().toString().substring(0, 15)}",
              style: pdf.TextStyle(fontSize: 20)),
          pdf.SizedBox(height: 30),
          pdf.Container(
            alignment: pdf.Alignment.topLeft,
            child: pdf.Text("${items_list}",
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
              child: pdf.Text("${sale_data_object['salesTotalAmount']}",
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
              child: pdf.Text("${items.length.toString()}",
                  style: pdf.TextStyle(fontSize: 20),
                  textAlign: pdf.TextAlign.right),
            ),
          ])),
          pdf.SizedBox(height: 35),
          pdf.Text(
              languages.skeleton_language_objects[config.app_language]
                  ['thant_you_and_come_again'],
              style: pdf.TextStyle(fontSize: 24)),
          pdf.Text("RE - PRINT",
              style: pdf.TextStyle(fontSize: 24),
              textAlign: pdf.TextAlign.center),
          pdf.SizedBox(height: 10),
        ]),
      ); // Center
    }));

    return doc.save();
  }
}
