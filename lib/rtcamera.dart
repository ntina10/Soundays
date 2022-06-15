import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test_zero/main.dart';
import 'package:test_zero/reqCam.dart';
import 'package:image/image.dart' as imglib;

class RtCamera extends StatefulWidget {
  const RtCamera({Key? key}) : super(key: key);

  @override
  _RtCameraState createState() => _RtCameraState();
}

class _RtCameraState extends State<RtCamera> {

  late final CameraController _controller;

  List<String>? _listEmotionStrings;
  List<String>? _listResultsStrings;
  late List<int> _theImg;
  File myfile = new File("assets/test_face.jpg");

  void _initializeCamera() async {
    final CameraController cameraController = CameraController(
      cameras[1],
      ResolutionPreset.high,
    );
    _controller = cameraController;

    _controller.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      setState(() {});

      await _controller.startImageStream((CameraImage availableImage) async {
        // var myimg = convertYUV420toImage(availableImage);
        await callApi(availableImage);
        await Future.delayed(Duration(seconds: 2));
      });

    });
  }

  // Future<Image?> convertYUV420toImageColor(CameraImage image) async {
  //   try {
  //     final int width = image.width;
  //     final int height = image.height;
  //     final int uvRowStride = image.planes[1].bytesPerRow;
  //     final int? uvPixelStride = image.planes[1].bytesPerPixel;
  //
  //     // print("uvRowStride: " + uvRowStride.toString());
  //     // print("uvPixelStride: " + uvPixelStride.toString());
  //
  //     // imgLib -> Image package from https://pub.dartlang.org/packages/image
  //     var img = imglib.Image(width, height); // Create Image buffer
  //
  //     // Fill image buffer with plane[0] from YUV420_888
  //     for(int x=0; x < width; x++) {
  //       for(int y=0; y < height; y++) {
  //         final int uvIndex = uvPixelStride! * (x/2).floor() + uvRowStride*(y/2).floor();
  //         final int index = y * width + x;
  //
  //         final yp = image.planes[0].bytes[index];
  //         final up = image.planes[1].bytes[uvIndex];
  //         final vp = image.planes[2].bytes[uvIndex];
  //         // Calculate pixel color
  //         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
  //         int g = (yp - up * 46549 / 131072 + 44 -vp * 93604 / 131072 + 91).round().clamp(0, 255);
  //         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
  //         // color: 0x FF  FF  FF  FF
  //         //           A   B   G   R
  //         img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
  //       }
  //     }
  //
  //     imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
  //     List<int> png = pngEncoder.encodeImage(img);
  //
  //     setState(() {
  //       print("it is happening");
  //       myfile.writeAsBytes(png);
  //     });
  //
  //     var newpng = Image.memory(Uint8List.fromList(png));
  //     setState((){
  //       _theImg = newpng;
  //     });
  //
  //     // muteYUVProcessing = false;
  //     return Image.memory(Uint8List.fromList(png));
  //   } catch (e) {
  //     print(">>>>>>>>>>>> ERROR:" + e.toString());
  //   }
  //   return null;
  // }

  /////////////////////////////////////////////////

  Future<List<int>?> convertImagetoPng(CameraImage image) async {
    try {
      imglib.Image img;
      if (image.format.group == ImageFormatGroup.yuv420) {
        img = _convertYUV420(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        img = _convertBGRA8888(image);
      } else {
        return null;
      }

      imglib.PngEncoder pngEncoder = new imglib.PngEncoder();

      // Convert to png
      List<int> png = pngEncoder.encodeImage(img);

      setState((){
        _theImg = png;
      });

      return png;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

// CameraImage BGRA8888 -> PNG
// Color
  imglib.Image _convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
  }

// CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
// Black
  imglib.Image _convertYUV420(CameraImage image) {
    var img = imglib.Image(image.width, image.height); // Create Image buffer

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0;
      planeOffset < image.height * image.width;
      planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        var newVal = shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        img.data[planeOffset + x] = newVal;
      }
    }

    return img;
  }

  Future<void> callApi(img) async {
    var url = Uri.parse('http://192.168.1.12:3000/temp');
    print("Stuck here before await getDataCam");

    //convert CameraImage to List<int>
    convertImagetoPng(img); //pass _theImg variable
    //convertYUV420toImageColor(img); //pass myfile variable
    //print("done");
    //pass List<int> to File object so that api getData() works
    //File thisImg = await File('assets/test_face.jpg').writeAsBytes(_theImg);
    //print("set go");

    var data = await getDataCam(_theImg, url);
    print("notHere");
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
    _initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ER camera'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
        children: <Widget>[
          CameraPreview(_controller),
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


