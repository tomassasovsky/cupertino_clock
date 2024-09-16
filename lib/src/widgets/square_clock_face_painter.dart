import 'dart:math';
import 'package:flutter/material.dart';

/// {@template square_clock_dashes_painter}
/// Custom painter for drawing the clock dashes.
/// {@endtemplate}
class SquareClockFacePainter extends CustomPainter {
  /// {@macro square_clock_dashes_painter}
  SquareClockFacePainter({
    required this.clockSize,
  });

  /// The size of the clock.
  final double clockSize;

  /// The color of the hour dashes.
  static const hourDashColor = Color(0xfff5f4f9);

  /// The color of the minute dashes.
  static const minuteDashColor = Color(0xff4a4a4a);

  @override
  void paint(Canvas canvas, Size size) {
    final padding = clockSize / 20;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = clockSize / 2;
    final sideLength = 2 * radius;
    final startRadius = radius / 1.3;

    final strokeWidthHour = clockSize / 100;
    final strokeWidthMinute = clockSize / 130;

    final hourPaint = Paint()
      ..color = hourDashColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthHour;

    final minutePaint = Paint()
      ..color = minuteDashColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidthMinute;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Function to calculate end points based on the square boundaries
    Offset calculateEndPoint(double angle) {
      final tanAngle = tan(angle);
      final isTopOrBottom = tanAngle.abs() > (size.height / size.width);
      double endX;
      double endY;

      if (isTopOrBottom) {
        // Top or bottom edge
        endY = center.dy + (angle < pi ? -sideLength / 2 : sideLength / 2);
        endX = center.dx + (endY - center.dy) / tanAngle;
      } else {
        // Left or right edge
        endX = center.dx +
            (angle < pi / 2 || angle > 3 * pi / 2
                ? sideLength / 2
                : -sideLength / 2);
        endY = center.dy + tanAngle * (endX - center.dx);
      }

      return Offset(endX, endY);
    }

    final sumNums = [7, 1, 0, 11, 6, 5];

    // Draw hour lines
    for (var i = 0; i < 12; i++) {
      final angle = 2 * pi * i / 12;
      final end = calculateEndPoint(angle);

      final cosAngle = cos(angle);
      final sinAngle = sin(angle);

      Offset start;
      if (sumNums.contains(i)) {
        start = Offset(
          center.dx + startRadius * cosAngle,
          center.dy + startRadius * sinAngle,
        );
      } else {
        start = Offset(
          center.dx - startRadius * cosAngle,
          center.dy - startRadius * sinAngle,
        );
      }

      canvas.drawLine(start, end, hourPaint);
    }

    // Draw minute lines
    for (var i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        // Avoid overwriting hour marks
        final angle = 2 * pi * i / 60;
        final end = calculateEndPoint(angle);
        final start = Offset(
          center.dx +
              (end.dx - center.dx) * 0.9, // Start closer to the end point
          center.dy + (end.dy - center.dy) * 0.9,
        );
        canvas.drawLine(start, end, minutePaint);
      }
    }
    for (var i = 0; i < 4; i++) {
      final angle = 2 * pi * i / 4;

      // Draw numbers
      final numberAngle = angle - pi / 2; // Rotate the numbers to be upright
      final numberX =
          center.dx + (radius - padding - radius / 3.5) * cos(numberAngle);
      final numberY =
          center.dy + (radius - padding - radius / 3) * sin(numberAngle);

      textPainter
        ..text = TextSpan(
          text: (i == 0 ? 12 : i * 3).toString(),
          style: TextStyle(
            fontSize: clockSize / 7,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'San Francisco',
            package: 'animated_analog_clock',
            height: 1,
          ),
        )
        ..layout()
        ..paint(
          canvas,
          Offset(
            numberX - textPainter.width / 2,
            numberY - textPainter.height / 2,
          ),
        );
    }
  }

  @override
  bool shouldRepaint(SquareClockFacePainter oldDelegate) {
    return oldDelegate.clockSize != clockSize;
  }
}
