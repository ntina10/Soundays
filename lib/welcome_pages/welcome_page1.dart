import 'package:flutter/material.dart';

class WelcomePage1 extends StatelessWidget {
  const WelcomePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100],
      child: Column(
        children: [
          SizedBox(height: 50,),
          Text(
            "Welcome\nto Soundays!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
          ),
          SizedBox(height: 20,),
          Text(
            "Today it’s sounday! Show us your\nface, and let us make music\nrecomendations accordingly",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontFamily: "Poppins",
            ),
          ),
          SizedBox(height: 40,),
          Container(height: 300,  width: 300, child: Image.asset('assets/sd1.png')),
        ],
      ),
    );
  }
}