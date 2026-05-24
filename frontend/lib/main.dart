import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Views/Screen1.dart';
import 'Screens/Views/Homepage.dart';
import 'Screens/Login-Signup/login.dart';     // ← Correct path to your login screen
import 'Screens/Utilis/assets_list.dart';

void main() {
  kAllAssets;

  runApp(
    const ProviderScope(
      child: Health101(),
    ),
  );
}

class Health101 extends ConsumerStatefulWidget {
  const Health101({super.key});

  @override
  ConsumerState<Health101> createState() => _Health101State();
}

class _Health101State extends ConsumerState<Health101> {
  Widget? _homeScreen;   // Will be set after auth check

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token != null && token.isNotEmpty) {
        // Token exists → Go directly to Homepage
        setState(() {
          _homeScreen = const Homepage();
        });
      } else {
        // No token → Show intro/login flow
        setState(() {
          _homeScreen = const Screen1();
        });
      }
    } catch (e) {
      print("Auth check error: $e");
      setState(() {
        _homeScreen = const Screen1();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: _homeScreen ?? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}