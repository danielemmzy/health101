import 'package:flutter/material.dart';
import 'package:health101/Screens/Utilis/assets_list.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:health101/Screens/Views/Screen1.dart';
import 'package:health101/Screens/Views/appointment.dart';
import 'package:health101/Screens/Views/doctor_details_screen.dart';
import 'package:health101/Screens/Views/doctor_search.dart';
import 'package:health101/Screens/Views/order_history_screen.dart';
import 'package:health101/Screens/Views/track_order_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


void main() {
  // THIS LINE FORCES ALL IMAGES INTO APK — NO PRECACHE NEEDED
  kAllAssets; // ← Just reading the list is enough!

  runApp(const Health101());
}

class Health101 extends StatelessWidget {
  const Health101({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Screen1(),
        );
      },
    );
  }
}