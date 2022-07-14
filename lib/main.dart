import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test_zero/mycamera.dart';
import 'package:test_zero/rtcamera.dart';
import 'package:test_zero/recoSong.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app
  try {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  } on CameraException catch (e) {
  debugPrint('CameraError: ${e.description}');
  }

  runApp(MaterialApp(
    routes: {
      '/camera': (context) => MyCamera(),
      '/rtcamera': (context) => RtCamera(),
      '/song': (context) => RecoSong(myemotion: 'Happy', mygenres: ['pop', 'rock'],),
    },
    title: 'Flutter Emotion Recognition',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        title: Text('Emotion Recognition'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 5.0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/camera');
                  },
                  child: Text("take a picture")),
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/rtcamera');
                  },
                  child: Text("real time camera")),
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/song');
                  },
                  child: Text("song recommender")),
            ],
          ),
        ),
      ),
    );
  }
}

