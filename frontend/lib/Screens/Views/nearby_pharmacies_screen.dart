// screens/nearby_pharmacies_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Models/pharmacy.dart';
import 'package:health101/Screens/Login-Signup/enable_location.dart';
import 'package:health101/Screens/Views/pharmacy_detail_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

 // ← DETAIL SCREEN
import '../widgets/pharmacy_card.dart';
import '../widgets/pharmacy_row.dart';

class NearbyPharmaciesScreen extends StatelessWidget {
  NearbyPharmaciesScreen({super.key});

  final List<Pharmacy> pharmacies = [
    Pharmacy(
      id: "pharm_1",
      imagePath: "assets/images/pharm1.png",
      name: "Health101 Pharmacy",
      address: "123 Main St, Anytown",
      rating: 4.5,
      openUntil: "9 PM",
      phone: "+1 555-0101",
      distance: "0.8",
    ),
    Pharmacy(
      id: "pharm_2",
      imagePath: "assets/images/pharm2.png",
      name: "Community Pharmacy",
      address: "456 Oak Ave, Anytown",
      rating: 4.2,
      openUntil: "8 PM",
      phone: "+1 555-0102",
      distance: "1.5",
    ),
    Pharmacy(
      id: "pharm_3",
      imagePath: "assets/images/pharm3.png",
      name: "Wellness Pharmacy",
      address: "789 Pine Ln, Anytown",
      rating: 4.8,
      openUntil: "10 PM",
      phone: "+1 555-0103",
      distance: "2.1",
    ),
    Pharmacy(
      id: "pharm_4",
      imagePath: "assets/images/pharm4.png",
      name: "MediCare Pharmacy",
      address: "321 Elm St, Anytown",
      rating: 4.6,
      openUntil: "11 PM",
      phone: "+1 555-0104",
      distance: "1.8",
    ),
    Pharmacy(
      id: "pharm_5",
      imagePath: "assets/images/pharm5.png",
      name: "QuickCare Drugs",
      address: "555 River Rd, Anytown",
      rating: 4.3,
      openUntil: "7 PM",
      phone: "+1 555-0105",
      distance: "3.2",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Nearby Pharmacies",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E2E2E),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // === DELIVERY ADDRESS BLOCK ===
Container(
  width: double.infinity,
  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.location_on, color: Color(0xFF339CFF), size: 20.sp),
          SizedBox(width: 8),
          Text(
            "Delivery Address",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "653 Nostrand Ave.",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  "Brooklyn, NY 11216",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(type: PageTransitionType.bottomToTop, child: EnableLocation()),
              );
            },
            child: Text(
              "Change",
              style: GoogleFonts.inter(
                color: Color(0xFF339CFF),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),

          // === SEARCH BAR ===
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5EDF4), width: 1),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for pharmacies",
                  hintStyle: TextStyle(fontSize: 15.sp, color: Colors.grey[600]),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      "assets/images/search.png",
                      width: 20,
                      height: 20,
                      color: const Color(0xFF339CFF),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // === HORIZONTAL PHARMACY CARDS (DASHBOARD STYLE) ===
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                final pharm = pharmacies[index];
                return Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: _buildTappableCard(pharm, context),
                );
              },
            ),
          ),

          SizedBox(height: 4.h),

          // === VERTICAL LIST (FULL VIEW) ===
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                final pharm = pharmacies[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: _buildTappableRow(pharm, context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ────── REUSABLE TAPPABLE CARD (HORIZONTAL) ──────
  Widget _buildTappableCard(Pharmacy pharm, BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetail(context, pharm),
      borderRadius: BorderRadius.circular(20),
      child: PharmacyCard(
        imagePath: pharm.imagePath,
        name: pharm.name,
        address: pharm.address,
        rating: pharm.rating,
        openUntil: pharm.openUntil,
      ),
    );
  }

  // ────── REUSABLE TAPPABLE ROW (VERTICAL) ──────
  Widget _buildTappableRow(Pharmacy pharm, BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetail(context, pharm),
      borderRadius: BorderRadius.circular(12),
      child: PharmacyRow(
        imagePath: pharm.imagePath,
        name: pharm.name,
        address: pharm.address,
        rating: pharm.rating,
        openUntil: pharm.openUntil,
      ),
    );
  }

  // ────── NAVIGATION TO DETAIL SCREEN ──────
  void _navigateToDetail(BuildContext context, Pharmacy pharm) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: PharmacyDetailScreen(pharmacy: pharm),
      ),
    );
  }
}