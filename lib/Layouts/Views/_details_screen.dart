import 'package:flutter/material.dart';

class details_screen extends StatefulWidget {

  details_screen(this.param_id);
  final param_id;

  @override
  _details_screenState createState() => _details_screenState(param_id);


}

class _details_screenState extends State<details_screen> {

  _details_screenState(this.param_id);
  final param_id;

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
