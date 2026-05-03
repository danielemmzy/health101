import 'package:flutter/material.dart';
import 'package:health101/Screens/Utilis/assets_list.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:health101/Screens/Views/Screen1.dart';
import 'package:health101/Screens/Views/appointment.dart';
import 'package:health101/Screens/Views/doctor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Import your screens
import 'Screens/Views/Screen1.dart';
import 'Screens/Views/Homepage.dart';
// import 'login.dart';           // Uncomment if you want to start from login

// This forces all images to be included in the APK
import 'Screens/Utilis/assets_list.dart';

void main() {
  // This line ensures all assets are bundled
  kAllAssets;

  runApp(
    const ProviderScope(          // ← THIS IS REQUIRED FOR RIVERPOD
      child: Health101(),
    ),
  );
}

class Health101 extends StatelessWidget {
  const Health101({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Screen1(),           // Change to const login() when ready
          // home: const login(),          // Uncomment when you want to test login screen
        );
      },
    );
  }
}