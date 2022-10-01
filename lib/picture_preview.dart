import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:soundays/animation_dots.dart';
import 'package:soundays/botNavBar.dart';
import 'package:soundays/emotion_screen.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/no_face_screen.dart';
import 'package:soundays/request.dart';
import 'package:soundays/globals.dart' as globals;

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

  //List<String>? _listEmotionStrings;
  late Map _map;

  bool in_progress = false;

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
        _map = newMap;
      });
      print('RIGHT HERE' + _map.toString());

    } else {
      setState(() {
        _faceFound = false;
      });
    }
    print('CALL API IS OVER');
    print('faceFound is ' + _faceFound.toString());
  }

  @override
  void initState() {
    super.initState();
    mygenres = widget.genresList;
    _imagePath = widget.imagePath;
    _getImageSize(File(_imagePath));
  }

  @override
  void dispose() {
    super.dispose();
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
        bottomNavigationBar: BotNavBar(mygenres: mygenres,),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),
              myTitle('Looking good!'),
              SizedBox(height: 48,),
              Transform.rotate(
                angle: - math.pi /30,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                    ),
                    elevation: 12,
                    child: SizedBox(
                      width: 270, //240
                      height: 350, //340
                      child:  Container(
                          width: 190,
                          height: 250,
                          child: _imageSize != null
                              ? Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 80.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.file(
                                    File(_imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          )  : Container(),
                        ),

                    ),
                  ),
                ),
              )
             ,
              SizedBox(height: 70,),
              Container(
                width: 240, //240
                height: 60, //60
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black, shape: StadiumBorder()),
                    onPressed: ! in_progress
                        ? () async {
                      setState(() {
                        in_progress = true;
                      });
                      //_repeatingController.repeat();
                      //_appearanceController.repeat();
                      await callApi(_imagePath);

                      if (_faceFound == true) {
                        //var myemotion = _map.keys.first;
                        //print("emotionRes " + myemotion);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmotionScreen(myEmotions: _map, myGenres: mygenres),
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
                        //add navigation to no-face Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NoFaceScreen(mygenres: mygenres),
                          ),
                        );
                      }
                    }
                    : () {},
                    child: ! in_progress
                        ? Text("Analyze my mood", style: TextStyle(color: Colors.white, fontSize: 16,  fontFamily: "Poppins"))
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 64.0),
                            child: AnimationDots()
                    )
                ),
              ),
              SizedBox(height: 24,),
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
                    SizedBox(width: 16,),
                    Text('Inaccurate? Retake photo', style: TextStyle(fontSize: 16.0, fontFamily: "Poppins",),),
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