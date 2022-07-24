import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_zero/request.dart';


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

    var url = Uri.parse('http://192.168.1.8:3000/emotion');

    var data = await getData(File(_imagePath), url);
    var decodedData = jsonDecode(data.body);

    List<String> emotionStrings = ["anger",  "disgust", "fear", "happiness", "neutral", "sadness", "surprise"];
    List<String> resultsStrings = [];

    for(var i in emotionStrings) {
      resultsStrings.add(decodedData['result'][i]['0'].toString());
    }

    setState(() {
      _listEmotionStrings = emotionStrings;
      _listResultsStrings = resultsStrings;
    });
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
                           // SingleChildScrollView(
                        // child:
                              _listEmotionStrings != null
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _listEmotionStrings!.length,
                          itemBuilder: (context, index) =>
                              Text(_listEmotionStrings![index] + ": " + _listResultsStrings![index]),
                            )
                            :
                             Container(
                               child: Center(
                                 child: CircularProgressIndicator(),
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
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}