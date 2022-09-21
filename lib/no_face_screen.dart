import 'package:flutter/material.dart';

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
      color: Colors.lightBlueAccent[100],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),
              Text(
                "No face detected!\nTry again",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height: 50,),
              Container(height: 300,  width: 300, child: Image.asset('assets/no_face.png')),
              SizedBox(height: 70,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black, shape: StadiumBorder()),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/take_pic', arguments: genres);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
                    child: Text("Retake photo", style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
