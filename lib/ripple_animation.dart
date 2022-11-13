import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class RippleAnimationPage extends StatelessWidget {
  const RippleAnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RippleAnimationView(
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

@immutable
class RippleAnimationView extends StatefulWidget {
  const RippleAnimationView({
    super.key,
    this.size = Size.zero,
    this.child,
  });

  final Widget? child;
  final Size size;

  @override
  State<RippleAnimationView> createState() => _RippleAnimationViewState();
}

class _RippleAnimationViewState extends State<RippleAnimationView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(_listener)
      ..addStatusListener(_statusListener);
    _animationController.forward();
  }

  void _listener() {
    setState(() {});
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _animationController.forward();
    } else if (status == AnimationStatus.completed) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController
      ..removeListener(_listener)
      ..removeStatusListener(_statusListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RippleAnimationPainter(
        animationValue: _animation.value,
      ),
      size: widget.size,
      child: widget.child,
    );
  }
}

class RippleAnimationPainter extends CustomPainter {
  final double animationValue;

  final Paint _ripplePaint;

  RippleAnimationPainter({required this.animationValue})
      : _ripplePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 3; i >= 0; i--) {
      circle(
        canvas,
        Rect.fromLTRB(0, 0, size.width, size.height),
        i + animationValue,
      );
    }
  }

  void circle(Canvas canvas, Rect rect, double value) {
    _ripplePaint.color =
        Colors.blueGrey.withOpacity(1 - (value / 4).clamp(.0, 1));

    canvas.drawCircle(
      rect.center,
      sqrt((rect.width * .5 * rect.width * .5) * value / 4),
      _ripplePaint,
    );
  }

  @override
  bool shouldRepaint(covariant RippleAnimationPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}
