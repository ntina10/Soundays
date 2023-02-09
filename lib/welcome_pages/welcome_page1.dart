import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

class WelcomePage1 extends StatelessWidget {
  const WelcomePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            // begin: Alignment.topLeft,
            // end: Alignment.bottomRight,
            radius: 2.7,
            // colors: [
            //   // Color(0xFF8D69FD),
            //   //Color(0xFFFFFFFF),
            //   Color.fromRGBO(189, 0, 255, 0.964792),
            //   Color.fromRGBO(220, 0, 134, 0.981469),
            //   Color(0xFFFF0000),
            //   Color(0xFF2400FF)
            // ],
            // stops: [
            //   4.33,
            //   5.901,
            //   5.902,
            //   7.14
            // ]
            center: Alignment(0.0, 0.70),
            colors: [
              Color.fromRGBO(189, 0, 255, 0.964792),
              Colors.transparent
            ]
          )),
        // linear-gradient(140.69deg, rgba(189, 0, 255, 0.964792) 43.31%, rgba(220, 0, 134, 0.981469) 59.01%, #FF0000 59.02%, #2400FF 71.42%);
      // color: Colors.green[100],
      child: Column(
        children: [
          myTextTop(context, "Welcome\nto moodle!", "Use moodle to listen to great music,\naccording to your mood."),
          SizedBox(height: MediaQuery.of(context).size.height / 8,),
          Container(height: 190,  width: 190, child: Image.asset('assets/fear.png')),
          SizedBox(height: MediaQuery.of(context).size.height / 8,)
        ],
      ),
    );
  }
}