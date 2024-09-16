import 'dart:math';
import 'package:flutter/material.dart';

/// {@template clock_dashes_painter}
/// Custom painter for drawing the clock dashes.
/// {@endtemplate}
class RoundClockFacePainter extends CustomPainter {
  /// {@macro clock_dashes_painter}
  RoundClockFacePainter({
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
    final hourDashLength = clockSize / 15;
    final minuteDashLength = clockSize / 30;

    final strokeWidthHour = clockSize / 85;
    final strokeWidthMinute = clockSize / 100;

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

    for (var i = 0; i < 12; i++) {
      final angle = 2 * pi * (i - 3) / 12;

      final startX = center.dx + (radius - padding) * cos(angle);
      final startY = center.dy + (radius - padding) * sin(angle);

      final endX =
          center.dx + (radius - padding - minuteDashLength) * cos(angle);
      final endY =
          center.dy + (radius - padding - minuteDashLength) * sin(angle);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), hourPaint);

      // Draw numbers
      // Adjust the angle for correct positioning
      final numberX = center.dx + (radius - hourDashLength * 2.5) * cos(angle);
      final numberY = center.dy + (radius - hourDashLength * 2.5) * sin(angle);

      textPainter
        ..text = TextSpan(
          text: (i == 0 ? 12 : i).toString(),
          style: TextStyle(
            fontSize: clockSize / 10,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'San Francisco',
            package: 'animated_analog_clock',
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

    // Draw minute and hour dashes
    for (var i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        final angle = 2 * pi * i / 60;

        final startX = center.dx + (radius - padding) * cos(angle);
        final startY = center.dy + (radius - padding) * sin(angle);

        final endX =
            center.dx + (radius - padding - minuteDashLength) * cos(angle);
        final endY =
            center.dy + (radius - padding - minuteDashLength) * sin(angle);

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          minutePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(RoundClockFacePainter oldDelegate) {
    return oldDelegate.clockSize != clockSize;
  }
}
