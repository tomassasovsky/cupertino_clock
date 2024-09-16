import 'dart:async';

import 'package:async/async.dart';
import 'package:cupertino_clock/src/widgets/hour_clock_hand.dart';
import 'package:cupertino_clock/src/widgets/minute_clock_hand.dart';
import 'package:cupertino_clock/src/widgets/round_clock_face_painter.dart';
import 'package:cupertino_clock/src/widgets/second_clock_hand.dart';
import 'package:cupertino_clock/src/widgets/square_clock_face_painter.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// {@template cupertino_analog_clock}
/// A Cupertino-styled analog clock.
/// {@endtemplate}
class CupertinoAnalogClock extends StatefulWidget {
  /// {@macro cupertino_analog_clock}
  const CupertinoAnalogClock.round({
    super.key,
    this.size,
    this.location,
  }) : _isSquare = false;

  /// {@macro cupertino_analog_clock}
  const CupertinoAnalogClock.square({
    super.key,
    this.size,
    this.location,
  }) : _isSquare = true;

  /// If this property is null then [size]
  /// value is [MediaQuery.of(context).size.height * 0.3].
  final double? size;

  /// If null, current location use for the timezone [DateTime.now()]
  ///
  /// Check out the timezone names from [this link](https://help.syncfusion.com/flutter/calendar/timezone).
  final String? location;

  final bool _isSquare;

  @override
  State<CupertinoAnalogClock> createState() => _CupertinoAnalogClockState();
}

class _CupertinoAnalogClockState extends State<CupertinoAnalogClock> {
  List<Timer> timers = <Timer>[];
  List<CancelableOperation<dynamic>> initFutures =
      <CancelableOperation<dynamic>>[];
  late ValueNotifier<DateTime> currentMinuteTime;
  late ValueNotifier<DateTime> currentHourTime;
  late ValueNotifier<DateTime> currentSecondTime;

  /// getter for getting specified location timezone
  DateTime get locationTime {
    final location = widget.location;
    if (location != null) {
      final currentLocation = tz.getLocation(location);
      return tz.TZDateTime.now(currentLocation);
    } else {
      return DateTime.now();
    }
  }

  void startClockTime() {
    timers.add(
      Timer.periodic(
        const Duration(milliseconds: 10),
        (timer) => currentSecondTime.value = locationTime,
      ),
    );

    // for the 5 second interval, calculate a delay until the following 5
    // second interval and start the timer there
    // meaning, the minute hand will move at
    // (:00, :05, :10, :15, :20, :25, :30, :35, :40, :45, :50, :55)
    initFutures
      ..add(
        CancelableOperation.fromFuture(
          Future.delayed(
            Duration(seconds: 5 - locationTime.second % 5),
            () {
              if (!mounted) return;
              timers.add(
                Timer.periodic(
                  const Duration(seconds: 5),
                  (timer) => currentMinuteTime.value = locationTime,
                ),
              );
            },
          ),
        ),
      )

      // for the half a minute interval to move the hour hand, calculate a
      // delay until the following 30 second interval and start the timer there
      // meaning, the minute hand will move at (:00, :30)
      ..add(
        CancelableOperation.fromFuture(
          Future.delayed(
            Duration(seconds: 30 - locationTime.second % 30),
            () {
              if (!mounted) return;
              timers.add(
                Timer.periodic(
                  const Duration(seconds: 30),
                  (timer) => currentHourTime.value = locationTime,
                ),
              );
            },
          ),
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    currentMinuteTime = ValueNotifier(locationTime);
    currentHourTime = ValueNotifier(locationTime);
    currentSecondTime = ValueNotifier(locationTime);
    startClockTime();
  }

  @override
  void dispose() {
    for (final future in initFutures) {
      future.cancel();
    }
    for (final timer in timers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? MediaQuery.sizeOf(context).height * 0.3;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget._isSquare)
            CustomPaint(
              size: Size(size, size),
              painter: SquareClockFacePainter(clockSize: size),
            )
          else
            CustomPaint(
              size: Size(size, size),
              painter: RoundClockFacePainter(clockSize: size),
            ),
          ValueListenableBuilder(
            valueListenable: currentMinuteTime,
            builder: (context, value, child) => HourClockHand(
              extend: widget._isSquare,
              currentTime: value,
              clockSize: size,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: currentMinuteTime,
            builder: (context, value, child) => MinuteClockHand(
              extend: widget._isSquare,
              currentTime: value,
              clockSize: size,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: currentSecondTime,
            builder: (context, value, child) => SecondClockHand(
              extend: widget._isSquare,
              currentTime: value,
              clockSize: size,
            ),
          ),
        ],
      ),
    );
  }
}
