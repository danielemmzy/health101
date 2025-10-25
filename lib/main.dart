import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:health101/Screens/Views/Screen1.dart';

/// Minimal app entry so tests can import `package:health101/main.dart`.
/// Provides a `health101` widget used by the widget_test.

void main() {
  runApp(const health101());
}

// ignore: camel_case_types
class health101 extends StatelessWidget {
  const health101({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Screen1(),
      );
    });
  }
}