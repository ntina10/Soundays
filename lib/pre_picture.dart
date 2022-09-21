import 'package:flutter/material.dart';

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

    return Container(
      color: Colors.lightBlueAccent[100],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),
              Text(
                "Let us have a peak\ninside your soul!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                "Show the cute face!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 40,),
              Container(height: 300,  width: 300, child: Image.asset('assets/sd2.png')),
              SizedBox(height: 70,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black, shape: StadiumBorder()),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/take_pic', arguments: mygenres);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
                    child: Text("Take a selfie!", style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
