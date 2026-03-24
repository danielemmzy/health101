// screens/on_board1.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnBoard1 extends StatelessWidget {
  const OnBoard1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Pure white background
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 8.h), // Top spacing

          // DOCTOR IMAGE — PURE WHITE, NO BORDER, CURVY EDGES
          Container(
            width: 85.w,
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.white, // Pure white background
              borderRadius: BorderRadius.circular(28), // Soft curvy edges
              image: const DecorationImage(
                image: AssetImage("assets/images/doctor1.png"),
                fit: BoxFit.contain, // Shows full image cleanly
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // TEXT CARD — PURE WHITE, NO GRADIENT, NO BORDER
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white, // Pure white
              borderRadius: BorderRadius.circular(20),
              
            ),
            child: Text(
              "Browse and buy medicines,\nmedical equipment \nand health essentials, all in one place",
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