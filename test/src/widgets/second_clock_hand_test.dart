import 'package:cupertino_clock/src/widgets/second_clock_hand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecondClockHand Tests', () {
    testWidgets('Painter should update when seconds or milliseconds change',
        (WidgetTester tester) async {
      final initialTime = DateTime(2022, 1, 1, 10, 10, 30, 500);
      final laterTime = DateTime(2022, 1, 1, 10, 10, 30, 800);

      final painter1 =
          SecondHandPainter(clockSize: 300, currentTime: initialTime);
      final painter2 =
          SecondHandPainter(clockSize: 300, currentTime: laterTime);

      expect(painter1.shouldRepaint(painter2), true);
    });

    testWidgets('Painter should not update if time is unchanged',
        (WidgetTester tester) async {
      final time = DateTime(2022, 1, 1, 10, 10, 30, 500);

      final painter1 = SecondHandPainter(clockSize: 300, currentTime: time);
      final painter2 = SecondHandPainter(clockSize: 300, currentTime: time);

      expect(painter1.shouldRepaint(painter2), false);
    });

    testWidgets('Second hand position is correctly calculated',
        (WidgetTester tester) async {
      const clockSize = 300.0;
      // Testing at a specific second and millisecond
      final time = DateTime(2022, 1, 1, 10, 15, 30, 250);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(), // Set the theme to dark
          home: Scaffold(
            body: CustomPaint(
              key: const Key('SecondHandPainter'),
              painter: SecondHandPainter(
                clockSize: clockSize,
                currentTime: time,
              ),
              child: const SizedBox(
                width: clockSize,
                height: clockSize,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(const Key('SecondHandPainter')),
        matchesGoldenFile('golden_tests/second_hand_1030250.png'),
      );
    });
  });
}
