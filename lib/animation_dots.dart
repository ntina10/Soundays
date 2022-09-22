import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimationDots extends StatefulWidget {

  @override
  _AnimationDotsState createState() => _AnimationDotsState();
}

class _AnimationDotsState extends State<AnimationDots> with TickerProviderStateMixin{

  //about flashing circles
  // late AnimationController _repeatingController;
  // final List<Interval> _dotIntervals = const [
  //   Interval(0.25, 0.8),
  //   Interval(0.35, 0.9),
  //   Interval(0.45, 1.0),
  // ];
  // Color flashingCircleDarkColor = const Color(0xFF333333);
  // Color flashingCircleBrightColor = const Color(0xFFaec1dd);

  //trials
  late AnimationController _appearanceController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _sizeAnimation2;
  late Animation<double> _sizeAnimation3;

  @override
  void initState() {
    super.initState();

    // _repeatingController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1500),
    // );

    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _sizeAnimation = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 14, end: 23),
            weight: 50,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 23, end: 14),
            weight: 50,
          ),
        ]
    ).animate(
        CurvedAnimation(parent: _appearanceController, curve: const Interval(0.25, 0.8))
    );

    _sizeAnimation2 = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 14, end: 23),
            weight: 50,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 23, end: 14),
            weight: 50,
          ),
        ]
    ).animate(
      CurvedAnimation(parent: _appearanceController, curve: const Interval(0.35, 0.9))
    );

    _sizeAnimation3 = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 14, end: 23),
            weight: 50,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 23, end: 14),
            weight: 50,
          ),
        ]
    ).animate(
        CurvedAnimation(parent: _appearanceController, curve: const Interval(0.45, 1.0))
    );

    //_repeatingController.repeat();
    _appearanceController.repeat();
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedBubble(
          animation: _sizeAnimation,
        ),
        AnimatedBubble(
          animation: _sizeAnimation2,
        ),
        AnimatedBubble(
          animation: _sizeAnimation3,
        ),
        // FlashingCircle(
        //   index: 0,
        //   repeatingController: _repeatingController,
        //   dotIntervals: _dotIntervals,
        //   flashingCircleDarkColor: flashingCircleDarkColor,
        //   flashingCircleBrightColor: flashingCircleBrightColor,
        // ),
        // FlashingCircle(
        //   index: 1,
        //   repeatingController: _repeatingController,
        //   dotIntervals: _dotIntervals,
        //   flashingCircleDarkColor: flashingCircleDarkColor,
        //   flashingCircleBrightColor: flashingCircleBrightColor,
        // ),
        // FlashingCircle(
        //   index: 2,
        //   repeatingController: _repeatingController,
        //   dotIntervals: _dotIntervals,
        //   flashingCircleDarkColor: flashingCircleDarkColor,
        //   flashingCircleBrightColor: flashingCircleBrightColor,
        // ),
      ],
    );
  }
}

class FlashingCircle extends StatelessWidget {
  const FlashingCircle({
    required this.index,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
  });

  final int index;
  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repeatingController,
      builder: (context, child) {
        final circleFlashPercent = dotIntervals[index].transform(
          repeatingController.value,
        );
        final circleColorPercent = math.sin(math.pi * circleFlashPercent);

        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              flashingCircleDarkColor,
              flashingCircleBrightColor,
              circleColorPercent,
            ),
          ),
        );
      },
    );
  }
}

class AnimatedBubble extends StatelessWidget {
  const AnimatedBubble({
    required this.animation,
  });

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipOval(
          child: Container(
            width: 14,
            height: animation.value,
            decoration: const BoxDecoration(
              //shape: BoxShape.circle,
              //borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
              color: Colors.white,
            ),
          ),
        );
        // return Transform.scale(
        //   scale: animation.value,
        //   alignment: Alignment.center,
        //   child: child,
        // );
      },
    );
  }
}
