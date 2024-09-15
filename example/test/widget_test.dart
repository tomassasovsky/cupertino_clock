import 'package:cupertino_clock/cupertino_clock.dart';
import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomClockExample Tests', () {
    testWidgets('CupertinoAnalogClock initializes with specified size',
        (WidgetTester tester) async {
      await tester.pumpWidget(const CustomClockExample());

      expect(find.byType(CupertinoAnalogClock), findsOneWidget);
    });
  });
}
