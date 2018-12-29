import 'package:flutter/material.dart';
import 'package:cognize/utility/constants.dart';

abstract class AppTheme {
  static ThemeData get getTheme => new ThemeData(
    primaryColor: Constants.primaryColor,
    accentColor: Colors.black,
    fontFamily: 'GoogleSans',
    scaffoldBackgroundColor: Constants.backgroundColor,
    dividerColor: Colors.black12,
    iconTheme: new IconThemeData(
      color: Colors.black
    ),
  );
}