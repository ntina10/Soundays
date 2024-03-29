import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:soundays/mycamera.dart';
import 'package:soundays/rtcamera.dart';
import 'package:soundays/recoSong.dart';
import 'package:soundays/choose_genres.dart';
import 'package:soundays/takeMyPic.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:soundays/welcome_pages/welcome_page1.dart';
import 'package:soundays/welcome_pages/welcome_page2.dart';
import 'package:soundays/welcome_pages/welcome_page3.dart';

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
    home: SplashScreen()
  )
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MyApp())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Image.asset('assets/splash_logo.png'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {

  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // appBar: AppBar(
      //   title: Text('Soundays'),
      //   centerTitle: true,
      //   backgroundColor: Colors.green[800],
      //   elevation: 5.0,
      // ),
      backgroundColor: Colors.redAccent,
      body: Stack(
        children: [

          PageView(
            controller: _controller,
            children: [
              WelcomePage1(),
              WelcomePage2(),
              WelcomePage3()
            ],
          ),


          // SizedBox(height: 200,),

          Container(
            alignment: Alignment(0, 0.45),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(dotColor:  Colors.white, activeDotColor:  Colors.white,),
            ),
          ),

          Positioned(
            left: 90,
            bottom: 80,
            child: ElevatedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/genres');
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: StadiumBorder()
                    // shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(2)))
                ),
                // ButtonStyle(
                //   backgroundColor: MaterialStateProperty.all(Colors.black),
                // ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
                  child: Text("Analyze my mood", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
            ),
          )
        ],
      ),
    );
  }
}

