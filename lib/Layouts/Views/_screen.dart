import 'package:flutter/material.dart';

class empty_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _empty_screenState();
  }
}

class _empty_screenState extends State<empty_screen> {

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      )
    );
  }
}
