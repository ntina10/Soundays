import 'package:flutter/material.dart';

Widget myButton(fun, String mytext) {
  return ElevatedButton(
    onPressed: fun,
    style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shape: StadiumBorder()
      // shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(2)))
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 24.0, 40.0, 24.0),
      child: Text(mytext, style: TextStyle(color: Colors.black, fontSize: 16,)),
    ),
  );
}
Widget myBlackButton(fun, String mytext) {
  return ElevatedButton(
    onPressed: fun,
    style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: StadiumBorder()
      // shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(2)))
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 24.0, 40.0, 24.0),
      child: Text(mytext, style: TextStyle(color: Colors.white, fontSize: 16,)),
    ),
  );
}

// Widget myButtonWithChild(fun, Widget mychild) {
//   return ElevatedButton(
//     onPressed: fun,
//     style: ElevatedButton.styleFrom(
//         primary: Colors.white,
//         shape: StadiumBorder()
//       // shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(2)))
//     ),
//     child: Padding(
//       padding: const EdgeInsets.fromLTRB(40.0, 24.0, 40.0, 24.0),
//       child: mychild,
//     ),
//   );
// }

Widget myTitle(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      // fontFamily: "Satoshi",
      fontStyle: FontStyle.normal,
      fontSize: 24.0,
      height: 1.125,
    ),
  );
}
Widget myBlackTitle(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      fontSize: 24.0,
      height: 1.125,
    ),
  );
}
Widget mySubtitle(String subtitle) {
  return Text(
    subtitle,
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white,
        // fontFamily: "Satoshi",
        fontStyle: FontStyle.normal,
        fontSize: 14.0,
        height: 1.36
    ),
  );
}
Widget myBlackSubtitle(String subtitle) {
  return Text(
    subtitle,
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.black,
        fontStyle: FontStyle.normal,
        fontSize: 14.0,
        height: 1.36
    ),
  );
}

Widget myTextTop(context, String title, String subtitle) {
  return Column(
    children: [
      SizedBox(height: MediaQuery.of(context).size.height / 8,),
      myTitle(title),
      SizedBox(height: 16,),
      mySubtitle(subtitle),
    ],
  );
}

Color myBgColor = Color(0xFF1B1919);

Map myColorMap = {
  'surprise': Color(0xFFC57DE2),
  'anger': Color(0xFFF9907F),
  'disgust': Color(0xFFABE79C),
  'fear': Color(0xFF8E74F9),
  'happiness': Color(0xFFFAD983),
  'sadness': Color(0xFF9CE4FF),
  'neutral': Color(0xFFF6F7FF)
};
