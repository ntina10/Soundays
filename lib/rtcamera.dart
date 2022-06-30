import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test_zero/main.dart';
import 'package:test_zero/request.dart';

class RtCamera extends StatefulWidget {
  const RtCamera({Key? key}) : super(key: key);

  @override
  _RtCameraState createState() => _RtCameraState();
}

class _RtCameraState extends State<RtCamera> {

  late CameraController _controller;

  bool _isDetecting = false;
  bool _faceFound = true;

  Timer? mytimer;

  List<String>? _listEmotionStrings;
  List<String>? _listResultsStrings;
  late List<int> _theImg;
  File myfile = new File("assets/test_face.jpg");

  Future<void> _initializeCamera() async {
    final CameraController cameraController = CameraController(
      cameras[1],
      ResolutionPreset.high,
    );
    _controller = cameraController;
    await _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    await Future.delayed(Duration(milliseconds: 500));

  }

  void handleTimeout() async {  // callback function
    // Do some work.
    await _takePicture().then((String? path) {
      if (path != null) {
        callApi(path);
      } else {
        print('Image path not found!');
      }
    });
  }

  Future<String?> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    String? imagePath;

    if (_controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }

    try {
      // Turning off the camera flash
      _controller.setFlashMode(FlashMode.off);
      // Returns the image in cross-platform file abstraction
      final XFile file = await _controller.takePicture();
      // Retrieving the path
      imagePath = file.path;
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }

  Future<void> callApi(mypath) async {

    var url = Uri.parse('http://192.168.1.5:3000/emotion');

    var data = await getData(File(mypath), url);
    var decodedData = jsonDecode(data.body);

    if (decodedData['result']['ans'] == null) {
      List<String> emotionStrings = [
        "anger",
        "disgust",
        "fear",
        "happiness",
        "neutral",
        "sadness",
        "surprise"
      ];
      List<String> resultsStrings = [];

      for (var i in emotionStrings) {
        resultsStrings.add(decodedData['result'][i]['0'].toString());
      }

      setState(() {
        _faceFound = true;
        _listEmotionStrings = emotionStrings;
        _listResultsStrings = resultsStrings;
      });
    } else {
      List<String> resultsStrings = [];
      resultsStrings.add("No Face Detected");
      setState(() {
        _faceFound = false;
        _listResultsStrings = resultsStrings;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    mytimer = Timer.periodic(Duration(milliseconds: 5000),
            (mytimer) async {  // callback function
          // Do some work.
          await _takePicture().then((String? path) {
            if (path != null) {
              callApi(path);
            } else {
              print('Image path not found!');
            }
          });
        }
    );
  }

  @override
  void dispose() {
    super.dispose();
    mytimer?.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ER camera'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
        children: <Widget>[
          CameraPreview(_controller),
          Container(
            height: 110,
            child:
            _faceFound != false
            ?
            _listEmotionStrings != null
                ? ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: _listEmotionStrings!.length,
              itemBuilder: (context, index) =>
                  Text(_listEmotionStrings![index] + ": " + _listResultsStrings![index]),
            )
                :
            Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
            :
              Container(
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text("No Face Detected")
                    ],
                  ),
              ),
              ),
          ),
        ],
      )
          : Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

}


