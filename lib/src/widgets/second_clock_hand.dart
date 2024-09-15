import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class SecondClockHand extends StatelessWidget {
  const SecondClockHand({
    required this.clockSize,
    required this.currentTime,
    super.key,
  });

  final double clockSize;
  final DateTime currentTime;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: SecondHandPainter(
          clockSize: clockSize,
          currentTime: currentTime,
        ),
      ),
    );
  }
}

@internal
class SecondHandPainter extends CustomPainter {
  SecondHandPainter({
    required this.clockSize,
    required this.currentTime,
  });

  final double clockSize;
  final DateTime currentTime;

  static const buttonSize = 3.0;
  static const buttonColor = Colors.black;
  static const secondHandColor = Color(0xffefa02c);

  @override
  void paint(Canvas canvas, Size size) {
    final angle =
        2 * pi * (currentTime.second + currentTime.millisecond / 1000) / 60;

    final center = Offset(size.width / 2, size.height / 2);
    final secondHandLength = clockSize / 2.2;
    final strokeWidthSecond = clockSize / 200;

    final secondPaint = Paint()
      ..color = secondHandColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthSecond;

    // use the buttonSize to create a circle around it, and then draw the main
    // part of the hand and the extension
    final buttonPaint = Paint()
      ..color = buttonColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = buttonSize;

    canvas
      ..drawLine(
        Offset(
          center.dx - sin(angle) * secondHandLength * 0.2,
          center.dy + cos(angle) * secondHandLength * 0.2,
        ),
        Offset(
          center.dx + sin(angle) * secondHandLength,
          center.dy - cos(angle) * secondHandLength,
        ),
        secondPaint,
      )
      ..drawCircle(center, buttonSize + strokeWidthSecond * 2, secondPaint)
      ..drawCircle(center, buttonSize, buttonPaint);
  }

  @override
  bool shouldRepaint(SecondHandPainter oldDelegate) {
    return oldDelegate.currentTime != currentTime ||
        oldDelegate.clockSize != clockSize;
  }

  @override
  bool shouldRebuildSemantics(SecondHandPainter oldDelegate) {
    return false;
  }
}
