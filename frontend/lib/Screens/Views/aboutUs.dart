// screens/about_us_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

// Replace with your actual screen


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // REAL HEALTH101 ACHIEVEMENTS
  final List<String> achievements = const [
    "Health101 is a leading digital pharmacy platform trusted by over 500,000+ patients across the nation, delivering prescription and OTC medications with 100% authenticity and same-day delivery.",
    "We partner with 10,000+ licensed pharmacies and 50+ top hospitals to ensure seamless access to quality healthcare, from medicines to lab tests and doctor consultations.",
    "Our AI-powered symptom checker and medication reminder system have helped 300,000+ users manage chronic conditions like diabetes, hypertension, and asthma with 95% adherence rate.",
    "Recognized by the Ministry of Health & Family Welfare for innovation in telemedicine, Health101 has facilitated 1.2 million+ virtual doctor consultations since 2023.",
    "We maintain a 4.9/5 customer satisfaction rating with 24/7 pharmacist support, secure payments, and cold-chain delivery for temperature-sensitive drugs like insulin and vaccines.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF333333), size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "About Us",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child: CartScreen()),
                );
              },
              child: Stack(
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        "7",
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INTRO
            Text(
              "Welcome to Health101",
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Your trusted partner in digital healthcare and pharmacy services.",
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                color: Color(0xFF666666),
                height: 1.6,
              ),
            ),
            SizedBox(height: 32),

            // ACHIEVEMENTS LIST
            ...achievements.asMap().entries.map((entry) {
              int index = entry.key;
              String text = entry.value;

              return Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BULLET POINT
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF339CFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 16),

                    // TEXT
                    Expanded(
                      child: Text(
                        text,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          color: Color(0xFF444444),
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: 20),

            // FOOTER TAGLINE
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF339CFF).withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  "Health101 — Delivering Care, One Click at a Time",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF339CFF),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}