import 'package:flutter/material.dart';
import 'package:soundays/botNavBar.dart';
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
      backgroundColor: myBgColor,
      //bottomNavigationBar: BotNavBar(mygenres: mygenres,),
      body: Center(
        child: Column(
          children: [
            myTextTop(context, "Let us have a peak\ninside your soul!", "Show the cute face!"),
            SizedBox(height: MediaQuery.of(context).size.height / 12.5,),
            Container(height: 270,  width: 270, child: Image.asset('assets/selfie.png')),
            SizedBox(height: MediaQuery.of(context).size.height / 6.7,),
            myButton(() async {await Navigator.pushNamed(context, '/take_pic', arguments: mygenres);}, "Take a selfie!"),
          ],
        ),
      ),
    );
  }
}