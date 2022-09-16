import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:soundays/mycamera.dart';
import 'package:soundays/rtcamera.dart';
import 'package:soundays/recoSong.dart';
import 'package:soundays/choose_genres.dart';
import 'package:soundays/takeMyPic.dart';

//hello world!

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
      '/take_pic': (context) => TakeMyPic(),
      '/song': (context) => RecoSong(myemotion: 'disgust', mygenres: ['pop'],),
      '/genres': (context) => ChooseGenres(),
    },
    title: 'Emotion Recognition and Song Recommendation',
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
                  child: Text("audio features testing")),
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/genres');
                  },
                  child: Text("song recommender")),
            ],
          ),
        ),
      ),
    );
  }
}

