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
              radius: 1.0,
              center: Alignment(0.0, 0.05),
              colors: [
                Color(0xFFFAD983),
                Color(0xFF232323)
              ]
          )),
      child: Column(
        children: [
          myTextTop(context, "Your mood\nin a playlist", "Moodle uses machine learning to\nanalyze your mood, and create a\nplaylist that 100% reflects your mood."),
          SizedBox(height: MediaQuery.of(context).size.height / 9.3,),
          Container(height: 170,  width: 170, child: Image.asset('assets/w3.png')),
        ],
      ),
    );
  }
}