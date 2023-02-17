import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soundays/myElements.dart';

class WelcomePage2 extends StatelessWidget {
  const WelcomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.purple[100],
      decoration: const BoxDecoration(
      gradient: RadialGradient(
          radius: 1.0,
          center: Alignment(0.0, 0.05),
          colors: [
            Color(0xFF8E74F9),
            Color(0xFF232323)
          ]
      )),
      child: Column(
        children: [
          myTextTop(context, "Moodle,\nmeet user", "First, you let us know a little bit about\nyour music taste. Then you take a\nselfie, expressing your mood."),
          SizedBox(height: 70,),
          Container(
            //height: MediaQuery.of(context).size.height / 3.6,
            height: 230,
            width: 230,
            child: Image.asset('assets/w2.png')
          )
        ],
      ),
    );
  }
}