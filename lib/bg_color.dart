import 'package:flutter/material.dart';

class BgColor extends StatefulWidget {
  final Widget mychild;
  const BgColor({Key? key, required this.mychild}) : super(key: key);

  @override
  _BgColorState createState() => _BgColorState();
}

class _BgColorState extends State<BgColor> with TickerProviderStateMixin {

  late AnimationController _positionController;

  late Animation<Offset> redAnimation;
  late Animation<Offset> pinkAnimation;
  late Animation<Offset> greenAnimation;
  late Animation<Offset> blueAnimation;

  late Widget _mychild;

  @override
  void initState() {
    super.initState();
    _mychild = widget.mychild;
    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    redAnimation = TweenSequence(
        <TweenSequenceItem<Offset>>[
          TweenSequenceItem(
            tween: BezierTween(
                    begin: Offset(-100, -100),
                    control: Offset(0, 300),
                    end: Offset(300, 300),
                  ),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: BezierTween(
                    begin: Offset(300, 300),
                    control: Offset(0, 300),
                    end: Offset(-100, -100),
                  ),
            weight: 50,
          ),
        ]
    ).animate( _positionController
        // CurvedAnimation(
        //     parent: _positionController, curve: const Interval(0.25, 0.8))
    );

    pinkAnimation = TweenSequence(
        <TweenSequenceItem<Offset>>[
          TweenSequenceItem(
            tween: BezierTween(
              begin: Offset(100, -100),
              control: Offset(0, 300),
              end: Offset(-200, -500),
            ),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: BezierTween(
              begin: Offset(-200, -500),
              control: Offset(0, 300),
              end: Offset(100, -100),
            ),
            weight: 50,
          ),
        ]
    ).animate(
      CurvedAnimation(
          parent: _positionController, curve: const Interval(0.05, 0.85))
    );

    greenAnimation = TweenSequence(
        <TweenSequenceItem<Offset>>[
          TweenSequenceItem(
            tween: BezierTween(
              begin: Offset(-400, 200),
              control: Offset(0, 300),
              end: Offset(0, 300),
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: BezierTween(
              begin: Offset(0, 300),
              control: Offset(50, 100),
              end: Offset(-50, 500),
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: BezierTween(
              begin: Offset(-50, 500),
              control: Offset(0, 100),
              end: Offset(-400, 200),
            ),
            weight: 1,
          ),
        ]
    ).animate(
      CurvedAnimation(
          parent: _positionController, curve: const Interval(0.15, 0.9))
    );

    blueAnimation = TweenSequence(
        <TweenSequenceItem<Offset>>[
          TweenSequenceItem(
            tween: BezierTween(
              begin: Offset(20, 500),
              control: Offset(-100, 300),
              end: Offset(300, -100),
            ),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: BezierTween(
              begin: Offset(300, -100),
              control: Offset(-100, 300),
              end: Offset(20, 500),
            ),
            weight: 50,
          ),
        ]
    ).animate(
      CurvedAnimation(
          parent: _positionController, curve: const Interval(0.25, 1.0))
    );

    _positionController.repeat();
  }

  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
          animation: _positionController,
          builder: (context, child) {
            return Stack(
              children: [
                CircleBubble(my_x: redAnimation.value.dx, my_y: redAnimation.value.dy, bubbleColor: Color(0xFFFCD06A)),
                CircleBubble(my_x: pinkAnimation.value.dx, my_y: pinkAnimation.value.dy, bubbleColor: Color(0xFFFCBBD7)),
                CircleBubble(my_x: greenAnimation.value.dx, my_y: greenAnimation.value.dy, bubbleColor: Color(0xFF99FF8A)),
                CircleBubble(my_x: blueAnimation.value.dx, my_y: blueAnimation.value.dy, bubbleColor: Color(0xFFA9CFEA)),
                _mychild,
              ],
            );
          }
      )
      // Stack(
      //   children: [


          // TweenAnimationBuilder(
          //   tween: BezierTween(
          //     begin: Offset(-100, -100),
          //     control: Offset(0, 300),
          //     end: Offset(300, 300),
          //   ),
          //   duration: Duration(seconds: 2),
          //   builder: (BuildContext context, Offset value, Widget? child) {
          //     return CircleBubble(my_x: value.dx, my_y: value.dy, bubbleColor: Color(0xFFFCD06A));
          //   },
          // ),

          // CircleBubble(my_x: 30, my_y: 30, bubbleColor: Color(0xFFFCD06A)),
          // CircleBubble(my_x: 70, my_y: 250, bubbleColor: Color(0xFFFCBBD7)),
          // CircleBubble(my_x: 80, my_y: 370, bubbleColor: Color(0xFF99FF8A)),
          // CircleBubble(my_x: 150, my_y: 500, bubbleColor: Color(0xFFA9CFEA)),
    //       Positioned(top: 200, left: 100, child: _mychild),
    //     ],
    //   ),
    // );
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
        width: 700,
        height: 700,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: Colors.white,
          gradient: RadialGradient(
            // begin: Alignment.centerLeft,
            // end: Alignment.centerRight,
            radius: 0.5,
            center: Alignment.center,
            colors: [
                bubbleColor,
                Colors.white.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }
}

class BezierTween extends Tween<Offset> {
  final Offset begin;
  final Offset end;
  final Offset control;

  BezierTween({required this.begin, required this.end, required this.control})
      : super(begin: begin, end: end);

  @override
  Offset lerp(double t) {
    final t1 = 1 - t;
    return begin * t1 * t1 + control * 2 * t1 * t + end * t * t;
  }
}
