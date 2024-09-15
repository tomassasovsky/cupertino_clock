import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class MinuteClockHand extends StatelessWidget {
  const MinuteClockHand({
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
        painter: MinuteHandPainter(
          clockSize: clockSize,
          currentTime: currentTime,
        ),
      ),
    );
  }
}

@internal
class MinuteHandPainter extends CustomPainter {
  MinuteHandPainter({
    required this.clockSize,
    required this.currentTime,
  });

  final double clockSize;
  final DateTime currentTime;

  static const buttonSize = 2.0;
  static const handColor = Color(0xfff5f4f9);

  @override
  void paint(Canvas canvas, Size size) {
    // Helper to convert elevation to sigma for blur effect
    double convertRadiusToSigma(double radius) {
      return radius * 0.57735 + 0.5;
    }

    final angle = 2 * pi * (currentTime.minute + currentTime.second / 60) / 60;
    final center = Offset(size.width / 2, size.height / 2);
    final lengthToThick = clockSize / 15;
    final handLength = clockSize / 2.35;
    final thinStrokeWidth = clockSize / 75;
    final thickStrokeWidth = clockSize / 40;

    // Drawing the thin part of the hour hand
    final thinEndPoint = Offset(
      center.dx + sin(angle) * lengthToThick,
      center.dy - cos(angle) * lengthToThick,
    );

    final thickEndPoint = Offset(
      center.dx + sin(angle) * handLength,
      center.dy - cos(angle) * handLength,
    );

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = thickStrokeWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(20))
      ..strokeCap = StrokeCap.round;

    final thinHandPaint = Paint()
      ..color = handColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thinStrokeWidth;

    final thickHandPaint = Paint()
      ..color = handColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickStrokeWidth;

    final buttonPaint = Paint()
      ..color = handColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickStrokeWidth;

    canvas
      ..drawLine(center, thinEndPoint, thinHandPaint)
      ..drawLine(thinEndPoint, thickEndPoint, shadowPaint)
      ..drawCircle(center, buttonSize, shadowPaint)
      ..drawLine(thinEndPoint, thickEndPoint, thickHandPaint)
      ..drawShadow(
        Path()
          ..addOval(Rect.fromCircle(center: center, radius: thickStrokeWidth)),
        Colors.black.withOpacity(0.5),
        5,
        true,
      )
      ..drawCircle(center, thickStrokeWidth, buttonPaint);
  }

  @override
  bool shouldRepaint(MinuteHandPainter oldDelegate) {
    return oldDelegate.clockSize != clockSize ||
        oldDelegate.currentTime != currentTime;
  }

  @override
  bool shouldRebuildSemantics(MinuteHandPainter oldDelegate) {
    return false;
  }
}
