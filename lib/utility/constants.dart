import 'package:flutter/material.dart';

abstract class Constants{
  static double title_font_size = 20.0;
  static FontWeight title_font_weight = FontWeight.w600;
  static Color primaryColor = const Color(0xFFdb5246);
  static Color _iconColor = new Color(0xFFcfcfcf);
  static Color mainHeaderColor = Colors.black;
  static Color dividerColor = Colors.grey;
  static Color imageBackground = Colors.grey.withOpacity(0.1);
  static Color backgroundColor = Colors.white;
  static Color textDarkColor = new Color(0xFF4A4A4A);
  static Color textLightColor = new Color(0xFF9b9b9b);

  static void snackBar(GlobalKey<ScaffoldState> key, String text){
    key.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }

  //urls
  static String TRANSLATE_URL = 'https://0qg0wcpzf2.execute-api.eu-west-1.amazonaws.com/stage/';

}