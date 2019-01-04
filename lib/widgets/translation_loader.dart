import 'package:flutter/material.dart';
import 'dart:async';

class TranslationLoader extends StatefulWidget {
  @override
  _State createState() {
    return new _State();
  }
}

class _State extends State<TranslationLoader> {

  bool _visible = true;
  double _color_opacity = 0.1;

  @override
  void initState() {

    _visible = false;
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.3,
      duration: new Duration(milliseconds: 400),
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                )
              ),
              SizedBox(height: 10.0),
              Container(
                width: 150.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
              ),
              SizedBox(height: 10.0),
            ]
          )
        )
    );
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 500);
    return new Timer(_duration, returnBody);
  }

  Container returnBody(){
    setState(() {
      _visible = !_visible;
      print(_visible);
    });
    startTime();
  }
}