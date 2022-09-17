import 'package:flutter/material.dart';

class WelcomePage3 extends StatelessWidget {
  const WelcomePage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[100],
      child: Column(
        children: [
          SizedBox(height: 50,),
          Text(
            "Sounday\nFunday!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
          ),
          SizedBox(height: 20,),
          Text(
            "That’s it! We analyze your\nemotions, and offer hand picked\nsongs just for you, according to\nyour mood!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontFamily: "Poppins",
            ),
          ),
          SizedBox(height: 10,),
          Container(height: 300,  width: 300, child: Image.asset('assets/sd3.png')),
        ],
      ),
    );
  }
}