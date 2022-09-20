import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:soundays/main.dart';
import 'package:soundays/recoSong.dart';
import 'package:soundays/request.dart';
import 'globals.dart' as globals;

//enum FaceStatus {yes, no, notYet}

class TakeMyPic extends StatefulWidget {
  const TakeMyPic({Key? key}) : super(key: key);

  @override
  _TakeMyPicState createState() => _TakeMyPicState();
}

class _TakeMyPicState extends State<TakeMyPic> {

  late CameraController _controller;
  // FaceStatus _faceFound = FaceStatus.notYet;
  bool _faceFound = true;

  Timer? mytimer;
  Duration myDuration = const Duration(seconds: 3);

  List<String> mydata = []; //genres we get from previous screen

  List<String>? _listEmotionStrings;
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

    var url = Uri.parse(globals.apiAddress + '/emotion');

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
      List<double> resultsD = [];
      print('hereeeeeee');

      for (var i in emotionStrings) {
        resultsD.add(decodedData['result'][i]['0']);
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
        _map = newMap;
      });
      print('in yes face variables are set');

    } else {

      setState(() {
        _faceFound = false;
      });

      print('in no face');
    }

    print('CALL API IS OVER');
    print('faceFound is ' + _faceFound.toString());

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
          print('Api was called');
          if (_faceFound == true) {
            // setState(() {
            //   _faceFound = true;
            // });
            print('faceFound2 is ' + _faceFound.toString());
            var emotionRes = _map.keys.first;

            print("emotionRes " + emotionRes);
            // add navigation to recoSong with data: _map (emotion) and selected genres
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecoSong(myemotion: emotionRes, mygenres: mydata),
              ),
            );
            print("Picture taken!!!");
            print(_map);
          } else if (_faceFound == false){
            print("No face is in this picture");
            print('faceFound3 is ' + _faceFound.toString());
            //recall the timer to take a second picture
            setState(() {
              //_faceFound = true;  //back to the default value
              myDuration = const Duration(seconds: 3);
              mytimer = Timer.periodic( const Duration(seconds: 1), (_) => setCountDown() );
            });

          }
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
      backgroundColor: Colors.white,
      body: _controller.value.isInitialized
          ?
          Center(
            child: Column(
              children: [
                SizedBox(height: 50,),
                Text('Get ready!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: "Poppins",),),
                SizedBox(height: 20,),
                Text('Show us the cute face!', style: TextStyle(fontSize: 16.0, fontFamily: "Poppins",),),
                SizedBox(height: 20,),
                Container(
                  height: 630,
                  width: 350,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CameraPreview(_controller),
                      ),
                      myDuration.inSeconds > -1 && myDuration.inSeconds != 0
                          ? Center(
                            child: Text(myDuration.inSeconds.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold, fontFamily: "Poppins",),)
                          )
                          : Center(
                            child: Column(children: const [
                                    Text("Your picture is ready! \nWait for the results..", textAlign: TextAlign.center, style: TextStyle(fontSize: 26.0, fontFamily: "Poppins",)),
                                CircularProgressIndicator()
                              ]),
                          )

                    ],
                  ),
                )
              ],
            ),
          )

      // Stack(
      //   children: <Widget>[
      //     CameraPreview(_controller),
      //     myDuration.inSeconds > -1
      //         ? Text("take picture in " + myDuration.inSeconds.toString())
      //         : _faceFound == true
      //           ? Column(children: const [
      //               Text("Your picture is ready! \nWait as we are getting the results.."),
      //               CircularProgressIndicator()
      //             ])
      //           : _faceFound == false
      //             ? Text("No Face Detected")
      //             : Container()
      //   ],
      // )
          : Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

}


