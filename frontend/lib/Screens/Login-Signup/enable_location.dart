import 'package:flutter/material.dart';
import 'package:health101/Screens/Login-Signup/location_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

class EnableLocation extends StatelessWidget {
  const EnableLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // ---------- Logo (Now: logo-green.png) ----------
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo-green.png', // Updated logo
                  height: 6.h,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 4.h),

              // ---------- Illustration (Perfectly Balanced) ----------
              ClipRRect(
                borderRadius: BorderRadius.circular(3.w),
                child: Container(
                  width: double.infinity,
                  height: 35.h, // Safe, responsive height
                  color: Colors.grey[100], // Optional fallback
                  child: Image.asset(
                    'assets/images/location_illus.png',
                    fit: BoxFit.contain, // Prevents top cropping
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

              SizedBox(height: 5.h),

              // ---------- Title ----------
              Text(
                'Enable Location',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF0C141C),
                  fontSize: 22.sp,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                  height: 1.27,
                ),
              ),

              SizedBox(height: 1.h),

              // ---------- Subtitle ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'To find the nearest pharmacy and get accurate delivery estimates, please enable location services.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF0C141C),
                    fontSize: 16.sp,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(),

              // ---------- Enable Button ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF339BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.w),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                     Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: const LocationPickerScreen()));
                    },
                    child: Text(
                      'Enable Location',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 253, 253, 253),
                        fontSize: 16.sp,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}