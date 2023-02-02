import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:soundays/main.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/picture_preview.dart';
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
  //late String img_path = '';
  // FaceStatus _faceFound = FaceStatus.notYet;
  // bool _faceFound = true;

  Timer? mytimer;
  Duration myDuration = const Duration(seconds: 4);

  List<String> mydata = []; //genres we get from previous screen

  // List<String>? _listEmotionStrings;
  // late Map _map;

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
      //await Future.delayed(Duration(seconds: 1));
      await _takePicture().then((String? path) async {
        if (path != null) {
          // setState(() {
          //   img_path = path;
          // });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PicturePreview(
                imagePath: path,
                genresList: mydata,
              ),
            ),
          );
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
      backgroundColor: myBgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: 50,),
          // Text('Get ready!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: "Poppins",),),
          // SizedBox(height: 20,),
          // Text('Show us the cute face!', style: TextStyle(fontSize: 16.0, fontFamily: "Poppins",),),
          myTextTop(context, 'Get ready!', 'Show us the cute face!'),
          SizedBox(height: MediaQuery.of(context).size.height / 16,),
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            //width: 300,
            color: Colors.white,
            child: _controller.value.isInitialized ? Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                          // img_path != '' ? Image.file(
                          //                     File(img_path),
                          //                     fit: BoxFit.cover,
                          //                   ) :
                                        CameraPreview(_controller),
                  ),
                ),
                myDuration.inSeconds < 4 && myDuration.inSeconds > 0
                    ? Center(
                      child: Text(myDuration.inSeconds.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 100.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Poppins",),)
                    )
                    : Container()
              ],
            ) : const SizedBox(
                  height: 30,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          )
        ],
      )
    );
  }

}


