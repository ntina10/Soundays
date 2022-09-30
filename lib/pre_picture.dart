import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

class PrePicture extends StatefulWidget {
  const PrePicture({Key? key}) : super(key: key);

  @override
  _PrePictureState createState() => _PrePictureState();
}

class _PrePictureState extends State<PrePicture> {
  List<String> mygenres = [];

  @override
  Widget build(BuildContext context) {
    mygenres = ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Column(
          children: [
            myTextTop("Let us have a peak\ninside your soul!", "Show the cute face!"),
            SizedBox(height: 64,),
            Container(height: 270,  width: 270, child: Image.asset('assets/no_face_img.png')),
            SizedBox(height: 120,),
            myButton(() async {await Navigator.pushNamed(context, '/take_pic', arguments: mygenres);}, "Take a selfie!"),
          ],
        ),
      ),
    );
  }
}
