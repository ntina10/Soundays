import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

class WelcomePage3 extends StatelessWidget {
  const WelcomePage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[100],
      child: Column(
        children: [
          myTextTop("Sounday\nFunday!", "That’s it! We analyze your emotions,\nand offer hand picked songs just fo\nyou, according to your mood!"),
          SizedBox(height: 75,),
          Container(height: 190,  width: 190, child: Image.asset('assets/main3.png')),
        ],
      ),
    );
  }
}