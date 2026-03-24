import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:health101/Screens/Views/all_products_screen.dart';
import 'package:health101/Screens/Views/moreView.dart';

import '../Login-Signup/Profile_screen.dart';
import '../Login-Signup/shedule_screen.dart';
import 'Dashboard_screen.dart';
import '../Widgets/TabbarPages/message_tab_all.dart';
import 'community_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int page = 0;

  final List<Widget> pages = [
    const Dashboard(),
    const message_tab_all(),
    const ScheduleScreen(),
    const AllProductsScreen(),
    const MoreView(),
  ];

  final List<IconData> icons = [
    Icons.home,
    Icons.message,
    Icons.schedule,
    Icons.production_quantity_limits,
    Icons.list_alt,
  ];

  final List<String> labels = [
    'Home',
    'Messages',
    'Consultations',
    'Products',
    'More',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[page],
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: icons.length,
        tabBuilder: (index, isActive) {
          final color = isActive ? const Color(0xFF339CFF) : Colors.grey.shade600;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Better vertical spacing
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icons[index],
                  size: 23, // 1px smaller than before
                  color: color,
                ),
                const SizedBox(height: 3), // Tighter label spacing
                Text(
                  labels[index],
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
        activeIndex: page,
        gapLocation: GapLocation.none,
        height: 78, // Slightly shorter for elegance
        splashSpeedInMilliseconds: 300,
        onTap: (index) => setState(() => page = index),
        backgroundColor: Colors.white,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        notchSmoothness: NotchSmoothness.softEdge,
        shadow: const Shadow(
          color: Colors.black12,
          blurRadius: 12,
          offset: Offset(0, -3),
        ),
        // Add safe area padding
      ),
    );
  }
}