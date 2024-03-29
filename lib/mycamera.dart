import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:soundays/main.dart';
import 'package:soundays/detailScreen.dart';

class MyCamera extends StatefulWidget {
  const MyCamera({Key? key}) : super(key: key);

  @override
  _MyCameraState createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> {

  late final CameraController _controller;

  void _initializeCamera() async {
    final CameraController cameraController = CameraController(
      cameras[1], //0: back camera, 1: front camera
      ResolutionPreset.high,
    );
    _controller = cameraController;

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Takes picture with the selected device camera, and
  // returns the image path
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

  @override
  void initState() {
    _initializeCamera();
    // final dir = Directory('/lib/images');
    // dir.deleteSync(recursive: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ER image'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
        children: <Widget>[
          CameraPreview(_controller),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                icon: Icon(Icons.camera),
                label: Text("Click"),
                onPressed: () async {
                  // If the returned path is not null, navigate
                  // to the DetailScreen
                  await _takePicture().then((String? path) {
                    if (path != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            imagePath: path,
                          ),
                        ),
                      );
                    } else {
                      print('Image path not found!');
                    }
                  });
                },
              ),
            ),
          )
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


