import 'package:flutter/material.dart';
import 'package:cognize/utility/constants.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:cognize/utility/customHttp.dart';
import 'dart:convert';

class Display extends StatefulWidget{
  var bundle;
  Display(this.bundle);
  @override
  _State createState(){
    return _State(this.bundle);
  }
}

class _State extends State<Display>{

  var bundle;
  var fullText = "";
  var translatedText = "";
  var imagePath = "";

  _State(this.bundle);

  @override
  void initState(){
    fullText = this.bundle["fullText"];
    imagePath = this.bundle["imagePath"];
    getHttpResponse();
  }

  void getHttpResponse() async {
    if(fullText.length > 0){
      var response = await CustomHttp.customPost(Constants.TRANSLATE_URL, jsonEncode({
        "fullText": fullText,
        "targetLanguage": "fr",
        "session": "abc"
      }));
      
    }
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Constants.primaryColor),
        elevation: 0.2,
        title: Text(
          "Cognize",
          style: TextStyle(
            color: Constants.primaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w500
          )
        )
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "Actual Text",
                style: TextStyle(
                  color: Color(0xffc4c4c4),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 2.0,
                      color: Color(0xffefefef)
                    )
                  )
                ),
                child: Text(
                  "\"" + fullText + "\"",
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "English",
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 5.0,),
                  GestureDetector(
                    onTap: (){AudioCache().play('lib/resources/english.mp3');},
                    child: Icon(Icons.volume_up, color: Color(0xffc4c4c4), size: 20.0,)
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Translation",
                style: TextStyle(
                  color: Color(0xffc4c4c4),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 2.0,
                      color: Color(0xffefefef)
                    )
                  )
                ),
                child: Text(
                  "\"" + translatedText + "\"",
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "French",
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 5.0,),
                  GestureDetector(
                    onTap: (){AudioCache().play('lib/resources/french.mp3');},
                    child: Icon(Icons.volume_up, color: Color(0xffc4c4c4), size: 20.0,)
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(image: ExactAssetImage(imagePath), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10.0)
                ),
              )
            ],
          )
        )
      ),
    );
  }
}