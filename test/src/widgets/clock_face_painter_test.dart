import 'package:cupertino_clock/src/widgets/round_clock_face_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClockFacePainter Tests', () {
    testWidgets(
      'Painter should redraw when clock size changes',
      (tester) async {
        final painter1 = RoundClockFacePainter(clockSize: 200);
        final painter2 = RoundClockFacePainter(clockSize: 300);

        expect(painter1.shouldRepaint(painter2), true);
      },
    );

    testWidgets(
      'Painter should not redraw when the clock size is unchanged',
      (tester) async {
        final painter1 = RoundClockFacePainter(clockSize: 200);
        final painter2 = RoundClockFacePainter(clockSize: 200);

        expect(painter1.shouldRepaint(painter2), false);
      },
    );

    testWidgets(
      'Should paint hour and minute dashes correctly',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: CustomPaint(
                key: const Key('ClockFacePainter'),
                painter: RoundClockFacePainter(clockSize: 300),
                child: const SizedBox(width: 300, height: 300),
              ),
            ),
          ),
        );

        await expectLater(
          find.byKey(const Key('ClockFacePainter')),
          matchesGoldenFile('golden_tests/clock_face_painter.png'),
        );
      },
    );
  });
}
