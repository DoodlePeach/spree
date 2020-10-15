import 'package:flutter/material.dart';
import 'package:spree/Layouts/Widgets/walkthrough.dart';
import 'package:spree/Utils/intro_screen_contents.dart';
import 'package:spree/Utils/navigation.dart';

class intro_screen extends StatefulWidget {
  @override
  intro_screenState createState() {
    return intro_screenState();
  }
}

class intro_screenState extends State<intro_screen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PageView(
              children: <Widget>[
                //Edit icons and data on intro screen
                Walkthrough(
                  title: intro_screen_contents.wt1,
                  content: intro_screen_contents.wc1,
                  imageIcon: Icons.signal_wifi_off,
                ),
                Walkthrough(
                  title: intro_screen_contents.wt2,
                  content: intro_screen_contents.wc2,
                  imageIcon: Icons.refresh,
                ),
                Walkthrough(
                  title: intro_screen_contents.wt3,
                  content: intro_screen_contents.wc3,
                  imageIcon: Icons.monetization_on,
                ),
                Walkthrough(
                  title: intro_screen_contents.wt4,
                  content: intro_screen_contents.wc4,
                  imageIcon: Icons.verified_user,
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(lastPage ? "" : intro_screen_contents.skip,
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0)),
                  onPressed: () =>
                      lastPage ? null : navigation.goSplash(context),
                ),
                FlatButton(
                  child: Text(
                      lastPage
                          ? intro_screen_contents.gotIt
                          : intro_screen_contents.next,
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0)),
                  onPressed: () => lastPage
                      ? navigation.goSplash(context)
                      : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
