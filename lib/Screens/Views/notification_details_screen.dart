// screens/notification_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final icon = notification["icon"] as IconData;
    final color = notification["color"] as Color;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("assets/images/back2.png", width: 28, height: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Notification", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            // Icon Card
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 3),
              ),
              child: Icon(icon, size: 44, color: color),
            ),
            SizedBox(height: 5.h),

            // Title
            Text(
              notification["title"],
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Time
            Text(
              notification["time"],
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 6.h),

            // Message Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF339CFF).withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Text(
                notification["message"],
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  height: 1.6,
                  color: const Color(0xFF2E2E2E),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            // Optional Action Button (example)
             ],
        ),
      ),
    );
  }
}