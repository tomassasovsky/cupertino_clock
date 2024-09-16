import 'package:cupertino_clock/src/widgets/minute_clock_hand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MinuteClockHand Tests', () {
    testWidgets(
      'Painter should update when minutes or seconds change',
      (tester) async {
        final initialTime = DateTime(2022, 1, 1, 10, 10); // 10:10:00
        final laterTime = DateTime(2022, 1, 1, 10, 11, 15); // 10:11:15

        final painter1 = MinuteHandPainter(
          extend: false,
          clockSize: 300,
          currentTime: initialTime,
        );
        final painter2 = MinuteHandPainter(
          extend: false,
          clockSize: 300,
          currentTime: laterTime,
        );

        expect(painter1.shouldRepaint(painter2), true);
      },
    );

    testWidgets(
      'Painter should not update if minutes and seconds are unchanged',
      (tester) async {
        final time = DateTime(2022, 1, 1, 10, 10, 30);

        final painter1 = MinuteHandPainter(
          extend: false,
          clockSize: 300,
          currentTime: time,
        );
        final painter2 = MinuteHandPainter(
          extend: false,
          clockSize: 300,
          currentTime: time,
        );

        expect(painter1.shouldRepaint(painter2), false);
      },
    );

    testWidgets(
      'Minute hand should render correctly at a specific time',
      (tester) async {
        const clockSize = 300.0;
        final time = DateTime(2022, 1, 1, 10, 15, 45); // 10:15:45
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(), // Set the theme to dark
            home: Scaffold(
              body: CustomPaint(
                key: const Key('MinuteHandPainter'),
                painter: MinuteHandPainter(
                  extend: false,
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
          find.byKey(const Key('MinuteHandPainter')),
          matchesGoldenFile('golden_tests/minute_hand_101545.png'),
        );
      },
    );
  });
}
