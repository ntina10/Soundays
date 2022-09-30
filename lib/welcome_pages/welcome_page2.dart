import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

class WelcomePage2 extends StatelessWidget {
  const WelcomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[100],
      child: Column(
        children: [
          myTextTop("How it\nworks", "Tell us what music you\nlike and take a selfie"),
          SizedBox(height: 28,),
          Container(
            height: 300,
            width: 300,
            child: Image.asset('assets/main2.png')
          )
        ],
      ),
    );
  }
}