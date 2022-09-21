import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:soundays/emotion_screen.dart';
import 'package:soundays/request.dart';
import 'globals.dart' as globals;

class PicturePreview extends StatefulWidget {
  final String imagePath;
  final List<String> genresList;

  const PicturePreview({required this.imagePath, required this.genresList});

  @override
  _PicturePreviewState createState() => _PicturePreviewState();
}

class _PicturePreviewState extends State<PicturePreview> with TickerProviderStateMixin {
  late final List<String> mygenres;
  late final String _imagePath;

  Size? _imageSize;

  bool _faceFound = true;

  List<String>? _listEmotionStrings;
  late Map _map;

  bool in_progress = false;

  //about flashing circles
  late AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1.0),
  ];
  Color flashingCircleDarkColor = const Color(0xFF333333);
  Color flashingCircleBrightColor = const Color(0xFFaec1dd);

  // Fetching the image size from the image file
  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.file(imageFile);

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;

    setState(() {
      _imageSize = imageSize;
    });
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

  @override
  void initState() {
    super.initState();
    mygenres = widget.genresList;
    _imagePath = widget.imagePath;
    //_recognizeEmotions();
    _getImageSize(File(_imagePath));

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _repeatingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8D69FD),
              Color(0xFFFFFFFF),
            ],
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 70,),
              Text('Looking good!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: "Poppins",),),
              SizedBox(height: 40,),
              _imageSize != null
              ? Transform.rotate(
                angle: math.pi /40,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Container(
                    //width: double.maxFinite,
                    //color: Colors.black,
                    width: 220,
                    height: 390,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                          File(_imagePath),
                        fit: BoxFit.cover,
                        ),

                    ),
                  ),
                ),
              )
              : Container(),
              // : Transform.rotate(
              //   angle: math.pi /40,
              //   child: Transform(
              //     alignment: Alignment.center,
              //     transform: Matrix4.rotationY(math.pi),
              //     child: Container(
              //       //width: double.maxFinite,
              //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white,),
              //       width: 220,
              //       height: 390,
              //     ),
              //   ),
              // ),
              SizedBox(height: 50,),
              // ! in_progress ?
              Container(
                width: 240,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black, shape: StadiumBorder()),
                    onPressed: ! in_progress
                        ? () async {
                      setState(() {
                        in_progress = true;
                      });
                      _repeatingController.repeat();
                      await callApi(_imagePath);

                      if (_faceFound == true) {
                        var myemotion = _map.keys.first;
                        print("emotionRes " + myemotion);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmotionScreen(myEmotion: myemotion, myGenres: mygenres),
                          ),
                        ).then((_) {
                          setState(() {
                            in_progress = false;
                          });
                        });
                        print("Picture taken!!!");
                        print(_map);
                      } else if (_faceFound == false){
                        print("No face is in this picture");
                        //add navigation to no-face Screen   ////////////////////////////////

                      }
                    }
                    : () {},
                    child: ! in_progress
                        ? Text("Analyze my mood", style: TextStyle(color: Colors.white, fontSize: 18,  fontFamily: "Poppins"))
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlashingCircle(
                            index: 0,
                            repeatingController: _repeatingController,
                            dotIntervals: _dotIntervals,
                            flashingCircleDarkColor: flashingCircleDarkColor,
                            flashingCircleBrightColor: flashingCircleBrightColor,
                          ),
                          FlashingCircle(
                            index: 1,
                            repeatingController: _repeatingController,
                            dotIntervals: _dotIntervals,
                            flashingCircleDarkColor: flashingCircleDarkColor,
                            flashingCircleBrightColor: flashingCircleBrightColor,
                          ),
                          FlashingCircle(
                            index: 2,
                            repeatingController: _repeatingController,
                            dotIntervals: _dotIntervals,
                            flashingCircleDarkColor: flashingCircleDarkColor,
                            flashingCircleBrightColor: flashingCircleBrightColor,
                          ),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(height: 20,),
              MaterialButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 27,
                      height: 27,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                      ),
                      child: Icon(Icons.autorenew),
                    ),
                    SizedBox(width: 10,),
                    Text('Inaccurate? Retake photo', style: TextStyle(fontSize: 14.0, fontFamily: "Poppins",),),
                  ],
                ),
                onPressed: () {
                  ///////////////////// mhpos edo push replacement?????????? ////////////////////////
                  Navigator.pushNamed(context, '/take_pic', arguments: mygenres);
                },
              ),
          ],
        ),
      ),
    ));
  }
}

class FlashingCircle extends StatelessWidget {
  const FlashingCircle({
    required this.index,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
  });

  final int index;
  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repeatingController,
      builder: (context, child) {
        final circleFlashPercent = dotIntervals[index].transform(
          repeatingController.value,
        );
        final circleColorPercent = math.sin(math.pi * circleFlashPercent);

        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              flashingCircleDarkColor,
              flashingCircleBrightColor,
              circleColorPercent,
            ),
          ),
        );
      },
    );
  }
}
