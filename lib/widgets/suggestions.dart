import 'package:flutter/material.dart';
import 'dart:convert';

class Suggestions extends StatelessWidget{
  var suggestions;
  Suggestions(this.suggestions);

  List<Widget> renderSuggestions(BuildContext context){
    List<Widget> list = [];
    suggestions.forEach((suggestion){
      list.add(
        Container(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Card(
            elevation: 2.0,
            color: Color(0xfffafafa),
            child: Container(
              width: MediaQuery.of(context).size.width - 40.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(suggestion["source"], style: TextStyle(
                    color: Color(0xffc4c4c4),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),),
                  SizedBox(height: 5.0),
                  Text(suggestion["target"], style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),)
                ]
              )
            ),
          )
        )
      );
    });
    return list;
  }

  Widget build(BuildContext context){
    return Container(
      child: Column(
        children: renderSuggestions(context),
      )
    );
  }
}