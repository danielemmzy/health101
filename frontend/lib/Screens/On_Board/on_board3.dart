// screens/on_board3.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnBoard3 extends StatelessWidget {
  const OnBoard3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),

          // DOCTOR IMAGE — PURE WHITE, NO BORDER, SOFT CURVES
          Container(
            width: 85.w,
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              image: const DecorationImage(
                image: AssetImage("assets/images/doctor3.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // TEXT CARD — PURE WHITE, ELEGANT SHADOW, CENTERED
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
             
            ),
            child: Text(
              "Discover pharmacies around you\nQuickly find a nearby pharmacy",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                height: 1.6,
              ),
            ),
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}