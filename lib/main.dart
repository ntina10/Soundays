import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:camera/camera.dart';
import 'package:soundays/bg_color.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/mycamera.dart';
import 'package:soundays/pre_picture.dart';
import 'package:soundays/rtcamera.dart';
import 'package:soundays/recoSong.dart';
import 'package:soundays/choose_genres.dart';
import 'package:soundays/takeMyPic.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:soundays/welcome_pages/welcome_page1.dart';
import 'package:soundays/welcome_pages/welcome_page2.dart';
import 'package:soundays/welcome_pages/welcome_page3.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('CameraError: ${e.description}');
  }

  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(
            routes: {
              '/camera': (context) => MyCamera(),
              '/rtcamera': (context) => RtCamera(),
              '/pre_pic': (context) => PrePicture(),
              '/take_pic': (context) => TakeMyPic(),
              //'/song': (context) => RecoSong(myemotion: 'disgust', mygenres: ['pop'],),
              '/genres': (context) => ChooseGenres(),
            },
            title: 'Emotion Recognition and Song Recommendation',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyApp() //SplashScreen()
      ))
  );

}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//         Duration(seconds: 3),
//             () => Navigator.of(context).pushReplacement(MaterialPageRoute(
//             builder: (BuildContext context) => MyApp())));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       body: Center(
//         child: Image.asset('assets/sound_logo.png'),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
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

            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(dotColor:  Colors.white, activeDotColor:  Colors.white, dotHeight: 16.0, dotWidth: 16.0),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 16,),
                  myButton(() async {
                    await Navigator.pushNamed(context, '/genres').then((value) => _controller.jumpToPage(0));
                    //await Navigator.push(context, MaterialPageRoute(builder: (context) => BgColor(mychild: Text('Hello'))));
                  }, 'Analyze my mood'),
                  SizedBox(height: MediaQuery.of(context).size.height / 9,)
                ],
              ),
            ),

          ],
        ),

    );
  }
}

