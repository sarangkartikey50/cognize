import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomHttp {
  static Future<http.Response> customPost(url, body){
    return http.post(url, body: body);
  }

  static Future<http.Response> customGet(url){
    return http.get(url);
  }
}