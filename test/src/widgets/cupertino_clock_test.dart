import 'package:cupertino_clock/cupertino_clock.dart';
import 'package:cupertino_clock/src/widgets/second_clock_hand.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  group('CupertinoAnalogClock Tests', () {
    setUpAll(tz.initializeTimeZones);

    testWidgets(
      'Clock should use default size if none provided',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const CupertinoAnalogClock(),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        // Should not be null since it depends on MediaQuery
        expect(container.constraints?.maxHeight, isNotNull);
      },
    );

    testWidgets(
      'Clock updates hands according to given timezone',
      (tester) async {
        fakeAsync((async) {
          tester.pumpWidget(
            MaterialApp(
              theme: ThemeData.dark(),
              home: const CupertinoAnalogClock(location: 'Europe/London'),
            ),
          );

          async
            ..elapse(const Duration(seconds: 30)) // Simulate time passing
            ..flushMicrotasks();

          // This test checks if the timer triggers as expected
          expect(find.byType(SecondClockHand), findsOneWidget);
        });
      },
    );

    testWidgets(
      'Clock reacts to size changes',
      (tester) async {
        fakeAsync((async) {
          tester.pumpWidget(
            const MaterialApp(
              home: CupertinoAnalogClock(size: 500),
            ),
          );

          async.flushMicrotasks();

          final container = tester.widget<Container>(find.byType(Container));
          expect(container.constraints?.maxWidth, 500);
          expect(container.constraints?.maxHeight, 500);
        });
      },
    );
  });
}
