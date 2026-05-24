import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Login-Signup/enable_location.dart';
import 'package:health101/Screens/Widgets/pharmacy_card.dart';
import 'package:health101/features/auth/providers/pharmacy_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../widgets/pharmacy_row.dart';
import 'pharmacy_detail_page.dart';


class NearbyPharmaciesScreen extends ConsumerStatefulWidget {
  const NearbyPharmaciesScreen({super.key});

  @override
  ConsumerState<NearbyPharmaciesScreen> createState() => _NearbyPharmaciesScreenState();
}

class _NearbyPharmaciesScreenState extends ConsumerState<NearbyPharmaciesScreen> {
  final double userLat = 6.5244;
  final double userLon = 3.3792;

  @override
  Widget build(BuildContext context) {
    final pharmaciesAsync = ref.watch(nearbyPharmaciesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Nearby Pharmacies",
          style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2E2E2E)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Delivery Address Block (same as before)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF339CFF), size: 20.sp),
                    SizedBox(width: 8),
                    Text("Delivery Address", style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("653 Nostrand Ave.", style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                          Text("Brooklyn, NY 11216", style: GoogleFonts.inter(fontSize: 14.sp, color: Color(0xFF666666))),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const EnableLocation())),
                      child: Text("Change", style: GoogleFonts.inter(color: Color(0xFF339CFF), fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Container(
              height: 56,
              decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(14)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for pharmacies",
                  prefixIcon: Padding(padding: const EdgeInsets.all(12), child: Image.asset("assets/images/search.png", width: 20, height: 20, color: const Color(0xFF339CFF))),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Dynamic Content
          Expanded(
            child: pharmaciesAsync.when(
              data: (pharmacies) {
                if (pharmacies.isEmpty) return const Center(child: Text("No pharmacies found"));

                return Column(
                  children: [
                    // Horizontal Cards
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
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: PharmacyDetailScreen(pharmacyId: pharm["id"]),
                                ),
                              ),
                              child: PharmacyCard(
                                imagePath: pharm["image_url"] ?? "assets/images/pharm1.png",
                                name: pharm["name"],
                                address: pharm["address"] ?? "",
                                rating: (pharm["rating"] ?? 4.5).toDouble(),
                                openUntil: pharm["opening_hours"] ?? "9 PM",
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Vertical List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        itemCount: pharmacies.length,
                        itemBuilder: (context, index) {
                          final pharm = pharmacies[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 3.h),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: PharmacyDetailScreen(pharmacyId: pharm["id"]),
                                ),
                              ),
                              child: PharmacyRow(
                                imagePath: pharm["image_url"] ?? "assets/images/pharm1.png",
                                name: pharm["name"],
                                address: pharm["address"] ?? "",
                                rating: (pharm["rating"] ?? 4.5).toDouble(),
                                openUntil: pharm["opening_hours"] ?? "9 PM",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text("Failed to load pharmacies")),
            ),
          ),
        ],
      ),
    );
  }
}