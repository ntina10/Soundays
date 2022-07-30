import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_zero/request.dart';
import 'globals.dart' as globals;
import 'package:test_zero/deleteImages.dart';


class DetailScreen extends StatefulWidget {
  final String imagePath;

  const DetailScreen({required this.imagePath});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final String _imagePath;

  Size? _imageSize;

  List<String>? _listEmotionStrings;
  List<String>? _listResultsStrings;

  bool _faceFound = true;
  late Map _map;

  late String imageFileName;

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


  void _recognizeEmotions() async {
    // Initialize the recognizer here
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    // final inputImage = Image.file(File(_imagePath));

    var url = Uri.parse(globals.apiAddress + '/emotion');

    var data = await getData(File(_imagePath), url);
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

      //imageFileName = decodedData['file'];

      setState(() {
        _faceFound = true;
        _listEmotionStrings = emotionStrings;
        _map = newMap;
      });
    } else {
      setState(() {
        _faceFound = false;
      });
    }
  }

  @override
  void initState() {
    _imagePath = widget.imagePath;
    _recognizeEmotions();
    _getImageSize(File(_imagePath));
    super.initState();
  }

  @override
  void dispose() {
    // Disposing the text detector when not used anymore
    // _textDetector.close();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    //deleteFile(imageFileName);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Details"),
      ),
      body: _imageSize != null
          ? Stack(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: _imageSize!.aspectRatio,
              child: Image.file(
                File(_imagePath),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Identified emotions - probability",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      child:
                      _faceFound != false
                          ? _listEmotionStrings != null
                            ? ListView.builder(
                                itemCount: _map.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String key = _map.keys.elementAt(index);
                                  return Text("$key" + ": " + "${(_map[key]*100).toStringAsFixed(3)} %");
                                },
                              )
                            : Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                          : Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("No Face Detected \n Try again!", textAlign: TextAlign.center,)
                                  ],
                                ),
                              ),
                            ),
                      ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}