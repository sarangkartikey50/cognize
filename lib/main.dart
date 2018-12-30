import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:cognize/utility/app_theme.dart';
import 'package:cognize/utility/constants.dart';

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
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState(){
    onNewCameraSelected(cameras[0]);
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
            rect: Rect.fromLTWH(MediaQuery.of(context).size.width/2 - 100.0, 50.0, 200.0, 100.0),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(15.0), topEnd:  Radius.circular(15.0)),
          color: Colors.white
        ),
        height: 250.0,
        child: new Center(
          child: Text("Tip: tap text to get the translation", style: TextStyle(
              color: Color(0xff333333),
              fontSize: 16.0,
              fontWeight: FontWeight.w500
            ),
          )
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
    final String dirPath = '${extDir.path}/Pictures/cognize';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
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
    );
  }
}

List<CameraDescription> cameras;

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(CameraApp());
}