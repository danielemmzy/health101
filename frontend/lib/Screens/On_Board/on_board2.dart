// screens/on_board2.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnBoard2 extends StatelessWidget {
  const OnBoard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),

          // DOCTOR IMAGE — PURE WHITE, NO BORDER, SOFT CORNERS
          Container(
            width: 85.w,
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              image: const DecorationImage(
                image: AssetImage("assets/images/doctor2.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // TEXT CARD — PURE WHITE, SUBTLE SHADOW, CENTERED
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              
            ),
            child: Text(
              "Connect with healthcare professionals\nBook online and offline appointments with specialists",
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
