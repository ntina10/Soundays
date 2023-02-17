import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimationDots extends StatefulWidget {

  @override
  _AnimationDotsState createState() => _AnimationDotsState();
}

class _AnimationDotsState extends State<AnimationDots> with SingleTickerProviderStateMixin{

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
      duration: const Duration(milliseconds: 1500),
    );

    _sizeAnimation = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 14, end: 24),
            weight: 50,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 24, end: 14),
            weight: 50,
          ),
        ]
    ).animate(
        CurvedAnimation(parent: _appearanceController, curve: const Interval(0.25, 0.8))
    );

    _sizeAnimation2 = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 14, end: 24),
            weight: 50,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 24, end: 14),
            weight: 50,
          ),
        ]
    ).animate(
      CurvedAnimation(parent: _appearanceController, curve: const Interval(0.35, 0.9))
    );

    _sizeAnimation3 = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 14, end: 24),
            weight: 50,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 24, end: 14),
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
        //SizedBox(width: 16,),
        AnimatedBubble(
          animation: _sizeAnimation2,
        ),
        //SizedBox(width: 16,),
        AnimatedBubble(
          animation: _sizeAnimation3,
        ),
      ],
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
              color: Color(0xFF1B1919),
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
