import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test_zero/mycamera.dart';
import 'package:test_zero/rtcamera.dart';
import 'package:test_zero/recoSong.dart';
import 'package:test_zero/choose_genres.dart';
import 'package:test_zero/takeMyPic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

List<CameraDescription> cameras = [];

void _launchurl() async {
  const url = 'spotify:track:3Vo4wInECJQuz9BIBMOu8i';

  try {
    await launchUrl(Uri.parse(url));
  } catch (err) {
    try {
      await launch('https://play.google.com/store/apps/details/?id=com.spotify.music&hl=el&gl=US');
    } catch (e) {
      throw 'e';
    }
  }
  // if (await canLaunch(url)) {    //canLaunch not working for some cases
  //   await launchUrl(Uri.parse(url));
  // } else if (await canLaunch('https://play.google.com/store/apps/details?id=com.spotify.music&hl=en_IN')) {
  //   await launch('https://play.google.com/store/apps/details?id=com.spotify.music&hl=en_IN');
  // } else {
  //   throw 'error';
  // }

}

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
      '/song': (context) => RecoSong(myemotion: 'sadness', mygenres: ['pop', 'rock', 'alternative'],),
      '/genres': (context) => ChooseGenres(),
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
  AudioPlayer _audioPlayer = new AudioPlayer();
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
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/genres');
                  },
                  child: Text("choose genres")),
              ElevatedButton(
                  onPressed: () async {
                    //await _audioPlayer.play(UrlSource('https://p.scdn.co/mp3-preview/bd6c0e165b80074444e4794ce07d8a416c3fe2dd?cid=774b29d4f13844c495f206cafdad9c86'));  //from "spotify" downloaded file
                      //UrlSource("https://api.spotify.com/v1/tracks/5jE48hhRu8E6zBDPRSkEq7")
                    _launchurl();
                  },
                  child: Text("the player testing")),
            ],
          ),
        ),
      ),
    );
  }
}

