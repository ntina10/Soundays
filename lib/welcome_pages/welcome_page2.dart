import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

class WelcomePage2 extends StatelessWidget {
  const WelcomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.purple[100],
      decoration: const BoxDecoration(
      gradient: RadialGradient(
          radius: 2.7,
          center: Alignment(0.0, 0.70),
          colors: [
            Color.fromRGBO(189, 0, 255, 0.964792),
            Colors.transparent
          ]
      )),
      child: Column(
        children: [
          myTextTop(context, "Moodle,\nmeet user", "First, you let us know a little bit about\nyour music taste. Then you take a\nselfie, expressing your mood."),
          SizedBox(height: 40,),
          Container(
            height: MediaQuery.of(context).size.height / 3.6,
            width: 210,
            child: Image.asset('assets/main2.png')
          )
        ],
      ),
    );
  }
}