import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

class WelcomePage1 extends StatelessWidget {
  const WelcomePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100],
      child: Column(
        children: [
          myTextTop("Welcome\nto Soundays!", "Today it’s sounday! Show us your\nface, and let us make music\nrecomendations accordingly"),
          SizedBox(height: 100,),
          Container(height: 145,  width: 200, child: Image.asset('assets/neutral.png')),
          SizedBox(height: 100,)
        ],
      ),
    );
  }
}