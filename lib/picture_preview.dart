import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:soundays/animation_dots.dart';
import 'package:soundays/botNavBar.dart';
import 'package:soundays/emotion_screen.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/no_face_screen.dart';
import 'package:soundays/request.dart';
import 'package:soundays/globals.dart' as globals;
// import 'package:fluttertoast/fluttertoast.dart';

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
    print("Returned data" + data.toString());

    if (data.statusCode == 200) {
      var decodedData = jsonDecode(data.body);
      print("Decoded data" + decodedData.toString());

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
    } else if (data.statusCode == 408) {
      print('error - connection timed out');

      setState(() {
        _faceFound = false;
        in_progress = false;
      });

      //throw alert message for timeout
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection timed out'),
            backgroundColor: Colors.red,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20),
            elevation: 30,
          )
      );
      // Fluttertoast.showToast(
      //     msg: "This is Center Short Toast",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
    } else {
      print('error - unknown error occurred');

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

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {getSize();});
  }

  @override
  void dispose() {
    super.dispose();
  }

  // final _myBeforeKey = GlobalKey();
  // getSize() {
  //   RenderBox _ob = _myBeforeKey.currentContext!.findRenderObject() as RenderBox;
  //   print(_ob.size.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         Color(0xFF8D69FD),
      //         Color(0xFFFFFFFF),
      //       ],
      //     )),
      child: Scaffold(
        backgroundColor: myBgColor,
        //bottomNavigationBar: BotNavBar(mygenres: mygenres,),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 8,),
              myTitle('Looking good!'),
              SizedBox(height: MediaQuery.of(context).size.height / 16,),
              Transform.rotate(
                angle: - math.pi /18.3,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    elevation: 12,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.45, //240
                      height: MediaQuery.of(context).size.height / 2.5, //320
                      child:  Container(
                          // width: MediaQuery.of(context).size.width / 1.9,
                          // height: MediaQuery.of(context).size.height / 3.2,
                          child: _imageSize != null
                              ? Padding(
                                padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 85.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
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
              SizedBox(height: MediaQuery.of(context).size.height / 13,), //61.5
              ElevatedButton(

                  style: ElevatedButton.styleFrom(primary: Colors.white, shape: StadiumBorder()),
                  onPressed: ! in_progress
                      ? () async {
                    setState(() {
                      in_progress = true;
                    });
                    //_repeatingController.repeat();
                    //_appearanceController.repeat();
                    await callApi(_imagePath);

                    if (_faceFound == true && in_progress) {
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
                    } else if (_faceFound == false && in_progress){
                      print("No face is in this picture");
                      //add navigation to no-face Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoFaceScreen(mygenres: mygenres),
                        ),
                      ).then((_) {
                        setState(() {
                          in_progress = false;
                        });
                      });
                    }
                  }
                  : () {},
                  child: ! in_progress
                      ? Padding(
                        padding: const EdgeInsets.fromLTRB(40.0, 24.0, 40.0, 24.0),
                        child: Text("Analyze my mood",
                            // key: _myBeforeKey,
                            style: TextStyle(color: Colors.black, fontSize: 16,)
                        ),
                  )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Container(width: 85, height: 70, child: AnimationDots())
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 32,),
              MaterialButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                      ),
                      child: Icon(Icons.autorenew),
                    ),
                    SizedBox(width: 16,),
                    Text('Inaccurate? Retake photo', style: TextStyle(color: Colors.white, fontSize: 14.0,),),
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