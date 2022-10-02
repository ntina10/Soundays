import 'package:flutter/material.dart';

class BotNavBar extends StatelessWidget {
  const BotNavBar({required this.mygenres});

  final List<String> mygenres;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80.0,right: 80.0),
      child: ClipRRect(
        // clipper: ShapeBorderClipper(
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
        //     )
        // ),
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
        child: Container(
          height: 60,
          margin: const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
          //color: Colors.grey,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 8.0,
              ),
            ]
          ),
          child:
          // BottomNavigationBar(
          //   showSelectedLabels: false,
          //   showUnselectedLabels: false,
          //   items: [
          //     BottomNavigationBarItem(icon: Icon(Icons.home_rounded, color: Colors.black,), label: 'Home'),
          //     BottomNavigationBarItem(icon: SizedBox(height: 24, child: Image.asset('assets/logo.png')), label: 'Retake picture'),
          //     BottomNavigationBarItem(icon: Icon(Icons.info_rounded, color: Colors.black,), label: 'Info'),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(
                  Icons.home_rounded,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              SizedBox(width: 20,),
              IconButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  //Navigator.pushNamed(context, '/take_pic', arguments: mygenres);
                },
                icon: SizedBox(height: 24, child: Image.asset('assets/logo.png')),
              ),
              SizedBox(width: 20,),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/rtcamera');
                },
                icon: const Icon(
                  Icons.info_rounded,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
