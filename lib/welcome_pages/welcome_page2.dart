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
          myTextTop(context, "How\nit works", "First, you let us know a little bit about\nyour music taste. Then you take a\nselfie, expressing your mood."),
          SizedBox(height: 28,),
          Container(
            height: MediaQuery.of(context).size.height / 2.67,
            width: 300,
            child: Image.asset('assets/main2.png')
          )
        ],
      ),
    );
  }
}