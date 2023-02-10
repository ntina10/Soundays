import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

class NoFaceScreen extends StatefulWidget {
  final List<String> mygenres;
  const NoFaceScreen({required this.mygenres});

  @override
  _NoFaceScreenState createState() => _NoFaceScreenState();
}

class _NoFaceScreenState extends State<NoFaceScreen> {
  late final List<String> genres;

  @override
  void initState() {
    super.initState();
    genres = widget.mygenres;

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
        backgroundColor: myBgColor,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),
              myTitle('No face detected!\nTry again.'),
              SizedBox(height: 100,),
              Container(height: 230,  width: 230, child: Image.asset('assets/no_face_new.png')),
              SizedBox(height: 112,),
              myButton(() async {
                await Navigator.pushNamed(context, '/take_pic', arguments: genres);
              }, 'Retake photo')
            ],
          ),
        ),
      ),
    );
  }
}
