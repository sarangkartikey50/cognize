import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CustomSharedPreferences {
  Future<SharedPreferences> _prefs;
  String targetLanguage;
  String targetLanguageCode;
  
  CustomSharedPreferences(){
    _prefs = SharedPreferences.getInstance();
    getPreferencesData();
  }

  void getPreferencesData() async {
    this.targetLanguage = await _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('targetLanguage') ?? "");
    });
    
    this.targetLanguageCode =  await _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('targetLanguageCode') ?? "");
    });
  }

  // String get _targetLanguage => targetLanguage;

  // String get _targetLanguageCode => targetLanguageCode;

  void saveLanguage(language, code) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("targetLanguage", language).then((bool success) {
      return language;
    });
    await prefs.setString("targetLanguageCode", code).then((bool success) {
      return code;
    });
    print("set language and code");
    targetLanguage = language;
    targetLanguageCode = code;
  }
}