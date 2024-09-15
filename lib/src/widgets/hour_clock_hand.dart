import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class HourClockHand extends StatelessWidget {
  const HourClockHand({
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
        painter: HourHandPainter(
          clockSize: clockSize,
          currentTime: currentTime,
        ),
      ),
    );
  }
}

@internal
class HourHandPainter extends CustomPainter {
  HourHandPainter({
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

    final angle = 2 * pi * (currentTime.hour + currentTime.minute / 60) / 12;
    final center = Offset(size.width / 2, size.height / 2);
    final lengthToThick = clockSize / 15;
    final hourHandLength = clockSize / 4;
    final thinStrokeWidth = clockSize / 75;
    final thickStrokeWidth = clockSize / 40;

    // Drawing the thin part of the hour hand
    final thinEndPoint = Offset(
      center.dx + sin(angle) * lengthToThick,
      center.dy - cos(angle) * lengthToThick,
    );

    final thickEndPoint = Offset(
      center.dx + sin(angle) * hourHandLength,
      center.dy - cos(angle) * hourHandLength,
    );

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = thickStrokeWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(20))
      ..strokeCap = StrokeCap.round;

    final thinHourHandPaint = Paint()
      ..color = handColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thinStrokeWidth;

    final thickHourHandPaint = Paint()
      ..color = handColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickStrokeWidth;

    final buttonPaint = Paint()
      ..color = handColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickStrokeWidth;

    canvas
      ..drawLine(center, thinEndPoint, thinHourHandPaint)
      ..drawLine(thinEndPoint, thickEndPoint, shadowPaint)
      ..drawCircle(center, buttonSize, shadowPaint)
      ..drawLine(thinEndPoint, thickEndPoint, thickHourHandPaint)
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
  bool shouldRepaint(HourHandPainter oldDelegate) {
    return oldDelegate.clockSize != clockSize ||
        oldDelegate.currentTime != currentTime;
  }

  @override
  bool shouldRebuildSemantics(HourHandPainter oldDelegate) {
    return false;
  }
}