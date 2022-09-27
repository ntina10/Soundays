import 'package:flutter/material.dart';

class WelcomePage2 extends StatelessWidget {
  const WelcomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[100],
      child: Column(
        children: [
          SizedBox(height: 50,),
          Text(
            "How it\nworks",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
            ),
          ),
          SizedBox(height: 20,),
          Text(
            "Tell us what music you\nlike and take a selfie",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontFamily: "Poppins",
            ),
          ),
          SizedBox(height: 40,),

          Container(
            height: 280,
            width: 280,
            child: Image.asset('assets/main2.png')
          )
          //Container(height: 300,  width: 300, child: Image.asset('assets/sd2.png')),
        ],
      ),
    );
  }
}