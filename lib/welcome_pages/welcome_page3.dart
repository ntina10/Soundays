import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

class WelcomePage3 extends StatelessWidget {
  const WelcomePage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.orange[100],
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
          myTextTop(context, "Your mood\nin a playlist", "Moodle uses machine learning to\nanalyze your mood, and create a\nplaylist that 100% reflects your mood."),
          SizedBox(height: MediaQuery.of(context).size.height / 10.67,),
          Container(height: 170,  width: 170, child: Image.asset('assets/main3.png')),
        ],
      ),
    );
  }
}