import 'package:cupertino_clock/cupertino_clock.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CustomClockExample());
}

class CustomClockExample extends StatelessWidget {
  const CustomClockExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CupertinoAnalogClock(size: 500),
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.dark,
    );
  }
}
