import 'package:flutter/material.dart';
import 'package:cognize/screens/splash.dart';
import 'package:cognize/utility/app_theme.dart';
import 'package:cognize/screens/home.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);
    FlutterStatusbarManager.setColor(
        Colors.transparent,
        animated: false);
    return new MaterialApp(
      theme: AppTheme.getTheme,
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => new Splash(),
        '/home': (BuildContext context) => new Home(),
      },
      home: Splash(),
    );
  }
}