import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test_zero/main.dart';
import 'package:test_zero/recoSong.dart';
import 'package:test_zero/request.dart';

class TakeMyPic extends StatefulWidget {
  const TakeMyPic({Key? key}) : super(key: key);

  @override
  _TakeMyPicState createState() => _TakeMyPicState();
}

class _TakeMyPicState extends State<TakeMyPic> {

  late CameraController _controller;
  bool _faceFound = true;

  Timer? mytimer;
  Duration myDuration = const Duration(seconds: 6);

  List<String> mydata = []; //genres we get from previous screen

  List<String>? _listEmotionStrings;
  List<String>? _listResultsStrings;
  late Map _map;

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

    var url = Uri.parse('http://192.168.1.8:3000/emotion');

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
      List<double> resultsD = [];

      for (var i in emotionStrings) {
        resultsD.add(decodedData['result'][i]['0']);
        resultsStrings.add(decodedData['result'][i]['0'].toString());
      }

      Map<String, double> map = Map.fromIterables(emotionStrings, resultsD);
      var sortedEntries = map.entries.toList()..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        if (diff == 0) diff = e2.key.compareTo(e1.key);
        return diff;
      });
      var newMap = Map<String, double>.fromEntries(sortedEntries);

      setState(() {
        _faceFound = true;
        _listEmotionStrings = emotionStrings;
        _listResultsStrings = resultsStrings;
        _map = newMap;
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

  void setCountDown() async {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        mytimer!.cancel();
        myDuration = Duration(seconds: seconds);
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
    if (myDuration == const Duration(seconds: 0)) {
      await _takePicture().then((String? path) async {
        if (path != null) {
          await callApi(path);
          var emotionRes = _map.keys.first;
          print("emotionRes " + emotionRes);
          // add navigation to recoSong with data: _map (emotion) and genres(?) (selected genres)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecoSong(myemotion: emotionRes, mygenres: mydata),
            ),
          );
          print("Picture taken!!!");
          print(_map);
        } else {
          print('Image path not found!');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    mytimer = Timer.periodic( const Duration(seconds: 1), (_) => setCountDown() );
  }

  @override
  void dispose() {
    super.dispose();
    mytimer?.cancel();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    mydata = ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('ER camera'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
        children: <Widget>[
          CameraPreview(_controller),
          myDuration.inSeconds > -1 ?
            Text("take picture in " + myDuration.inSeconds.toString())
              : Text("Your picture is ready! \nLets get the results.."),
          Container(
            height: 110,
            child:
            _faceFound != false
                ?
                null
            // _listEmotionStrings != null
            //     ? ListView.builder(
            //   itemCount: _map.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     String key = _map.keys.elementAt(index);
            //     return Text("$key" + ": " + "${_map[key]}");
            //   },
            // )
            //     :
            // Container(
            //   child: Center(
            //     child: CircularProgressIndicator(),
            //   ),
            // )
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


