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
          myTextTop(context, "Welcome\nto Soundays!", "Use soundays to listen to great music,\naccording to your mood."),
          SizedBox(height: MediaQuery.of(context).size.height / 8,),
          Container(height: 145,  width: 200, child: Image.asset('assets/neutral.png')),
          SizedBox(height: MediaQuery.of(context).size.height / 8,)
        ],
      ),
    );
  }
}