import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cognize/utility/app_theme.dart';
import 'package:cognize/utility/constants.dart';
import 'package:cognize/utility/config.dart';
import 'package:cognize/screens/display.dart';
import 'package:aws_ai/src/RekognitionHandler.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:cognize/utility/custom_shared_preferences.dart';

List<String> _languages = const <String>['Arabic', 'Chinese (Simplified)', 'Chinese (Traditional)', 'Czech', 'Danish', 'Dutch', 'English', 'Finnish', 'French', 'German', 'Hebrew', 'Indonesian', 'Italian', 'Japanese', 'Korean', 'Polish', 'Portuguese', 'Russian', 'Spanish', 'Swedish', 'Turkish'];
const _languagesMap = [
  {'language': 'Arabic', 'code': 'ar'},
  {'language': 'Chinese (Simplified)', 'code': 'zh'},
  {'language': 'Chinese (Traditional)', 'code': 'zh-TW'},
  {'language': 'Czech', 'code':'cs'},
  {'language': 'Danish', 'code':'da'},
  {'language': 'Dutch', 'code':'nl'},
  {'language': 'English', 'code':'en'},
  {'language': 'Finnish', 'code':'fi'},
  {'language': 'French', 'code':'fr'},
  {'language': 'German', 'code':'de'},
  {'language': 'Hebrew', 'code':'he'},
  {'language': 'Indonesian', 'code':'id'},
  {'language': 'Italian', 'code':'it'},
  {'language': 'Japanese', 'code':'ja'},
  {'language': 'Korean', 'code':'ko'},
  {'language': 'Polish', 'code':'pl'},
  {'language': 'Portuguese', 'code':'pt'},
  {'language': 'Russian', 'code':'ru'},
  {'language': 'Spanish', 'code':'es'},
  {'language': 'Swedish', 'code':'sv'},
  {'language': 'Turkish', 'code':'tr'}
];

typedef void MyFormCallback(String value);

class LanguageForm extends StatefulWidget {
  final MyFormCallback onSubmit;

  LanguageForm({this.onSubmit});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<LanguageForm> {
  String _radioValue = "";

  List<Widget> renderRadioList(){
    List<Widget> _list = [];
    _languagesMap.forEach((item){
      _list.add(Container(
        child: Row(
          children: <Widget>[
            Radio(
              value: item["code"],
              groupValue: _radioValue,
              onChanged: (value) => setState(() => this._radioValue = value),
            ),
            Text(item["language"])
          ]
        )
      ));
    });
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 0.0),
      title: Text(
        "Choose your language",
        style: TextStyle(
          color: Color(0xff333333),
          fontSize: 16.0,
          fontWeight: FontWeight.w600
        ),
        textAlign: TextAlign.left,
      ),
      content: Container(
        height: 250.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: renderRadioList(),
          )
        )
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onSubmit(_radioValue);
            },
            child: new Text("Select", style: TextStyle(
              color: Color(0xff333333),
              fontWeight: FontWeight.w600,
              fontSize: 14.0
            ),)
        ),new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Text("Cancel", style: TextStyle(
              color: Color(0xff333333),
              fontWeight: FontWeight.w600,
              fontSize: 14.0
            ),)
        ),
      ]
    );
  }
}

class CameraExampleHome extends StatefulWidget {
  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraExampleHomeState extends State<CameraExampleHome> {
  CameraController controller;
  String imagePath;
  String videoPath;
  VoidCallback videoPlayerListener;
  String languageCode = "";
  String targetLanguage = "";
  CustomSharedPreferences _prefs = new CustomSharedPreferences();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    onNewCameraSelected(cameras[0]);
    languageCode = _prefs.targetLanguageCode;
    targetLanguage = _prefs.targetLanguage;
  }

  void onSubmit(String result) {
    for(var language in _languagesMap){
      if(language["code"] == result){
        setState(() {
          languageCode = result;
          targetLanguage = language["language"];
        });
        _prefs.saveLanguage(targetLanguage, languageCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: new GestureDetector(
              onTap: cameraClicked,
              child: _cameraPreviewWidget()
            )
          ),
          Positioned.fromRect(
            rect: Rect.fromLTWH(-20.0, 50.0, 200.0, 100.0),
            child: Container(
              height: 100.0,
              child: Text(
                "Cognize",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w500
                )
              )
            )
          ),
          Positioned.fromRect(
            rect: Rect.fromLTWH(MediaQuery.of(context).size.width - 150.0, 10.0, 200.0, 100.0),
            child: Container(
              height: 100.0,
              child: InkWell(
                child: Icon(Icons.translate, color: Colors.white, size: 20.0,),
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (context) => LanguageForm(onSubmit: onSubmit),
                  );
                },
              )
            )
          ),
          Positioned.fromRect(
            rect: Rect.fromLTWH(0.0, MediaQuery.of(context).size.height - 60.0, MediaQuery.of(context).size.width, 60.0),
            child: GestureDetector(
              onTap: showPersistentBottomSheet,
              child: Container(
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(15.0), topEnd:  Radius.circular(15.0)),
                  color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      height: 25.0,
                      child: Icon(Icons.maximize, size: 30.0, color: Color(0xffe1e1e1))
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text("Tip: tap text to get the translation", style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                      ), textAlign: TextAlign.left,)
                    )
                  ],
                )
              )
            )
          )
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      final size = MediaQuery.of(context).size;
      final deviceRatio = size.width / size.height;
      return Transform.scale(
        scale: controller.value.aspectRatio / deviceRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
      );
    }
  }



  void cameraClicked(){
    onTakePictureButtonPressed();
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void showPersistentBottomSheet(){
    _scaffoldKey.currentState.showBottomSheet((context){
      return new Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(15.0), topEnd:  Radius.circular(15.0)),
          color: Colors.white
        ),
        height: 250.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5.0),
              height: 25.0,
              child: Icon(Icons.maximize, size: 30.0, color: Color(0xffe1e1e1))
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text("Tip: tap text to get the translation", style: TextStyle(
                color: Color(0xff333333),
                fontSize: 16.0,
                fontWeight: FontWeight.w500
              ), textAlign: TextAlign.left,)
            ),
            SizedBox(height: 10.0),
            Divider(color: Color(0xffe1e1e1), height: 2.0,),
            SizedBox(height: 20.0,),
            Row(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25.0)
                  ),
                  child: Icon(Icons.hearing, size: 25.0, color: Constants.primaryColor),
                ),
                SizedBox(width: 10.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Audio Translation", style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff333333),
                      fontSize: 16.0,
                    ), textAlign: TextAlign.left,),
                    Text("Tap on text get audio translation in multiple languages.", style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff666666),
                      fontSize: 12.0,
                    )),
                  ],
                )
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Color(0xff64a35a).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25.0)
                  ),
                  child: Icon(Icons.translate, size: 25.0, color: Color(0xff64a35a)),
                ),
                SizedBox(width: 10.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Text Translation", style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff333333),
                      fontSize: 16.0,
                    ), textAlign: TextAlign.left,),
                    Text("Tap on text get text translation in multiple languages.", style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff666666),
                      fontSize: 12.0,
                    )),
                  ],
                )
              ],
            )
          ],
        ),
      );
    });
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
      recognizeText(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void recognizeText(path){
    File sourceImagefile = File(path);

    RekognitionHandler rekognition = new RekognitionHandler(Config.AWS_ACCESSKEY, Config.AWS_SECRETKEY, Config.AWS_REGION);
    Future<String> labelsArray = rekognition.detectText(sourceImagefile);

    String fullText = "";

    labelsArray.then((res) {
      var responseArray = jsonDecode(res);
      print(res);
      var textDetections = responseArray["TextDetections"];
      print(textDetections.toString());
      for(var i=0; i<textDetections.length; i++){
        if(textDetections[i]["Type"] == "LINE"){
          fullText = fullText + " " + textDetections[i]["DetectedText"];
        }
        if(textDetections[i]["Type"] == "WORD")
          break;
      }

      if(fullText.length > 0 && targetLanguage.length > 0){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Display({"fullText": fullText, "imagePath": path, "targetLanguage": targetLanguage, "languageCode": languageCode}),
          ),
        );
      } else {
        showInSnackBar("Please select your language!");
      }
    });
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.getTheme,
      home: CameraExampleHome(),
      routes: <String, WidgetBuilder>{
        '/display': (BuildContext context) => new Display({"fullText": ""}),
      }
    );
  }
}

List<CameraDescription> cameras;

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
    final Directory dir = await getApplicationDocumentsDirectory();
    final Directory picturesPath = Directory('${dir.path}/Pictures/');
    final Directory audioPath = Directory('${dir.path}/Audio/');

    if(picturesPath.existsSync())
      picturesPath.deleteSync(recursive: true);
    else
      picturesPath.createSync(recursive: true);
    if(audioPath.existsSync())
      audioPath.deleteSync(recursive: true);
    else
      audioPath.createSync(recursive: true);
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(CameraApp());
}