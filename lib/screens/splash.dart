import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
// import 'package:ladakh_navigator/database/sql_db.dart';
// import 'package:ladakh_navigator/utility/custom_http.dart';
// import 'package:ladakh_navigator/utility/internet_connectivity.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:cognize/utility/constants.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {


  @override
  void initState(){
    startTime();
  }

  @override
  void dispose(){
    super.dispose();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
      Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);
    FlutterStatusbarManager.setColor(
        Colors.transparent,
        animated: false
    );
    return new Scaffold(
      body: new Container(
        //decoration: new BgGradient().getGradient(),
        height: double.infinity,
        width: double.infinity,
        decoration: new BoxDecoration(
          // image: new DecorationImage(image: new ExactAssetImage('images/background/4.jpg'),
          //     fit: BoxFit.fill
          // ),
          color: Color(0xffffffff)
        ),
        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset("images/logo/logo-white.png",
            //   height: 120.0,
            //   width: 120.0,
            // ),
            new Text(
              'Cognize'.toUpperCase(),
              style: new TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 36.0,
                  fontFamily: 'GoogleSans',
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
            new SizedBox(
              height: 5.0,
            ),
            new Text(
                'Click. Get.'.toUpperCase(),
                style: new TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 16.0,
                  fontFamily: 'GoogleSans',
                  fontWeight: FontWeight.w400
                ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}