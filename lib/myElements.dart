import 'package:flutter/material.dart';

Widget myButton(fun, String mytext) {
  return ElevatedButton(
    onPressed: fun,
    style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: StadiumBorder()
      // shape: const RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(2)))
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
      child: Text(mytext, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins')),
    ),
  );
}

Widget myTitle(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
      fontStyle: FontStyle.normal,
      fontSize: 24.0,
      height: 1.17,
    ),
  );
}
Widget mySubtitle(String subtitle) {
  return Text(
    subtitle,
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.black,
        fontFamily: "Poppins",
        fontStyle: FontStyle.normal,
        fontSize: 16.0,
        height: 1.5
    ),
  );
}

Widget myTextTop(String title, String subtitle) {
  return Column(
    children: [
      SizedBox(height: 100,),
      myTitle(title),
      SizedBox(height: 16,),
      mySubtitle(subtitle),
    ],
  );
}
