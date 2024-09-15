import 'package:cupertino_clock/src/widgets/hour_clock_hand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HourClockHand Tests', () {
    testWidgets(
      'Painter should update when time changes',
      (tester) async {
        final initialTime = DateTime(2022, 1, 1, 10);
        final laterTime = DateTime(2022, 1, 1, 11);

        final painter1 =
            HourHandPainter(clockSize: 300, currentTime: initialTime);
        final painter2 =
            HourHandPainter(clockSize: 300, currentTime: laterTime);

        expect(painter1.shouldRepaint(painter2), true);
      },
    );

    testWidgets(
      'Painter should not update if time is unchanged',
      (tester) async {
        final time = DateTime(2022, 1, 1, 10);

        final painter1 = HourHandPainter(clockSize: 300, currentTime: time);
        final painter2 = HourHandPainter(clockSize: 300, currentTime: time);

        expect(painter1.shouldRepaint(painter2), false);
      },
    );

    testWidgets(
      'Hour hand position is correctly calculated',
      (tester) async {
        const clockSize = 300.0;
        final time = DateTime(2022, 1, 1, 3);
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: CustomPaint(
                key: const Key('HourHandPainter'),
                painter: HourHandPainter(
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
          find.byKey(const Key('HourHandPainter')),
          matchesGoldenFile('golden_tests/hour_hand_3am.png'),
        );
      },
    );
  });
}
