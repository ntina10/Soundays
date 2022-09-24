import 'package:flutter/material.dart';

class BgColor extends StatefulWidget {
  final Widget mychild;
  const BgColor({Key? key, required this.mychild}) : super(key: key);

  @override
  _BgColorState createState() => _BgColorState();
}

class _BgColorState extends State<BgColor> with TickerProviderStateMixin {

  late AnimationController _positionController;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _bubbleAnimation2;
  late Animation<double> _bubbleAnimation3;
  late Animation<double> _bubbleAnimation4;

  @override
  void initState() {
    super.initState();

    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // _bubbleAnimation = TweenSequence(
    //     <TweenSequenceItem<double>>[
    //       TweenSequenceItem<double>(
    //         tween: Tween<double>(begin: 14, end: 23),
    //         weight: 50,
    //       ),
    //       TweenSequenceItem<double>(
    //         tween: Tween<double>(begin: 23, end: 14),
    //         weight: 50,
    //       ),
    //     ]
    // ).animate(
    //     CurvedAnimation(
    //         parent: _positionController, curve: const Interval(0.25, 0.8))
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CircleBubble(my_x: 30, my_y: 30, bubbleColor: Color(0xFFFCD06A)),
          CircleBubble(my_x: 50, my_y: 190, bubbleColor: Color(0xFFFCBBD7)),
          CircleBubble(my_x: 80, my_y: 370, bubbleColor: Color(0xFF99FF8A)),
          CircleBubble(my_x: 150, my_y: 500, bubbleColor: Color(0xFFA9CFEA)),
        ],
      ),
    );
  }
}

class CircleBubble extends StatelessWidget {
  const CircleBubble({
    //required this.size,
    required this.my_x,
    required this.my_y,
    required this.bubbleColor,
  });

  //final double size;
  final double my_y;
  final double my_x;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: my_y,
      left: my_x,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: Colors.white,
          gradient: RadialGradient(
            // begin: Alignment.centerLeft,
            // end: Alignment.centerRight,
            radius: 2.0,
            center: Alignment.center,
            colors: [
                bubbleColor,
                Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
