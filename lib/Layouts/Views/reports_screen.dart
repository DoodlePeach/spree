import 'package:flutter/material.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class reports_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _reports_screenState();
  }
}

class _reports_screenState extends State<reports_screen> {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Center(
          child: Container(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: Container(
                              height: 70,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          languages.skeleton_language_objects[
                                                  config.app_language]
                                              ['total_sales'],
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black87,
                                              fontFamily: "Roboto"),
                                        ),
                                        Text(
                                          "   ${config.store_sales.length} ${languages.skeleton_language_objects[config.app_language]['sales']}",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black54,
                                              fontFamily: "Roboto"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            child: Ink(
                                                decoration: ShapeDecoration(
                                                  color: Colors.teal,
                                                  shape: CircleBorder(),
                                                ),
                                                child: IconButton(
                                                  icon:
                                                      Icon(Icons.shopping_cart),
                                                  color: Colors.white,
                                                  onPressed: () {},
                                                )))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 20,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: Card(
                                color: Colors.white,
                                elevation: 2.0,
                                child: Container(
                                  height: 135,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Ink(
                                              decoration: ShapeDecoration(
                                                color: Colors.teal,
                                                shape: CircleBorder(),
                                              ),
                                              child: IconButton(
                                                icon:
                                                    Icon(Icons.favorite_border),
                                                color: Colors.white,
                                                onPressed: () {},
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              languages.skeleton_language_objects[
                                                      config.app_language]
                                                  ['total_customers'],
                                              style: new TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87,
                                                  fontFamily: "Roboto"),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${config.store_customers.length} ${languages.skeleton_language_objects[config.app_language]['customers']}",
                                              style: new TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black54,
                                                  fontFamily: "Roboto"),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                          flex: 20,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: Card(
                                color: Colors.white,
                                elevation: 2.0,
                                child: Container(
                                  height: 135,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Ink(
                                              decoration: ShapeDecoration(
                                                color: Colors.teal,
                                                shape: CircleBorder(),
                                              ),
                                              child: IconButton(
                                                icon: Icon(Icons.security),
                                                color: Colors.white,
                                                onPressed: () {},
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              languages.skeleton_language_objects[
                                                      config.app_language]
                                                  ['total_suppliers'],
                                              style: new TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87,
                                                  fontFamily: "Roboto"),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${config.store_suppliers.length} ${languages.skeleton_language_objects[config.app_language]['suppliers']}",
                                              style: new TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black54,
                                                  fontFamily: "Roboto"),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: Container(
                              height: 70,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          languages.skeleton_language_objects[
                                                  config.app_language]
                                              ['total_inventory'],
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black87,
                                              fontFamily: "Roboto"),
                                        ),
                                        Text(
                                          "${config.store_inventory.length} ${languages.skeleton_language_objects[config.app_language]['items']}",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black54,
                                              fontFamily: "Roboto"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            child: Ink(
                                                decoration: ShapeDecoration(
                                                  color: Colors.teal,
                                                  shape: CircleBorder(),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.dns),
                                                  color: Colors.white,
                                                  onPressed: () {},
                                                )))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 20,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: Card(
                                color: Colors.white,
                                elevation: 2.0,
                                child: Container(
                                  height: 135,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Ink(
                                              decoration: ShapeDecoration(
                                                color: Colors.teal,
                                                shape: CircleBorder(),
                                              ),
                                              child: IconButton(
                                                icon: Icon(Icons.computer),
                                                color: Colors.white,
                                                onPressed: () {},
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              languages.skeleton_language_objects[
                                                      config.app_language]
                                                  ['total_devices'],
                                              style: new TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87,
                                                  fontFamily: "Roboto"),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${config.store_devices.length} ${languages.skeleton_language_objects[config.app_language]['devices']}",
                                              style: new TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black54,
                                                  fontFamily: "Roboto"),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                          flex: 20,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: Card(
                                color: Colors.white,
                                elevation: 2.0,
                                child: Container(
                                  height: 135,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Ink(
                                              decoration: ShapeDecoration(
                                                color: Colors.teal,
                                                shape: CircleBorder(),
                                              ),
                                              child: IconButton(
                                                icon:
                                                    Icon(Icons.shopping_basket),
                                                color: Colors.white,
                                                onPressed: () {},
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              languages.skeleton_language_objects[
                                                      config.app_language]
                                                  ['total_purchases'],
                                              style: new TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87,
                                                  fontFamily: "Roboto"),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${config.store_purchases.length} ${languages.skeleton_language_objects[config.app_language]['purchases']}",
                                              style: new TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black54,
                                                  fontFamily: "Roboto"),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: Container(
                              height: 70,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          languages.skeleton_language_objects[
                                                  config.app_language]
                                              ['total_stalls'],
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black87,
                                              fontFamily: "Roboto"),
                                        ),
                                        Text(
                                          "${config.store_stalls.length} ${languages.skeleton_language_objects[config.app_language]['stalls']}",
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black54,
                                              fontFamily: "Roboto"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            child: Ink(
                                                decoration: ShapeDecoration(
                                                  color: Colors.teal,
                                                  shape: CircleBorder(),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.home),
                                                  color: Colors.white,
                                                  onPressed: () {},
                                                )))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
