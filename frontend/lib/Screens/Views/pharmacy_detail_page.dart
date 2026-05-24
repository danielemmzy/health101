import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/features/auth/providers/pharmacy_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


import '../widgets/round_icon_button.dart';
import 'all_products_screen.dart';
import 'cart_screen.dart';

class PharmacyDetailScreen extends ConsumerWidget {
  final int pharmacyId;

  const PharmacyDetailScreen({super.key, required this.pharmacyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmacyAsync = ref.watch(pharmacyDetailProvider(pharmacyId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: pharmacyAsync.when(
        data: (pharmacy) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // Hero Image
              Hero(
                tag: "pharmacy_$pharmacyId",
                child: SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: Image.network(
                    pharmacy["image_url"] ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: Icon(Icons.local_pharmacy, size: 20.w, color: Colors.grey)),
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.black54, Colors.transparent, Colors.black87], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),

              SingleChildScrollView(
                padding: EdgeInsets.only(top: 100.w - 8.h),
                child: Container(
                  width: 100.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pharmacy["name"], style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w800, color: const Color(0xFF0C141C))),
                        SizedBox(height: 1.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              initialRating: (pharmacy["rating"] ?? 4.5).toDouble(),
                              minRating: 1,
                              itemSize: 16.sp,
                              ignoreGestures: true,
                              itemBuilder: (_, __) => const Icon(Icons.star, color: Color(0xFF339CFF)),
                              onRatingUpdate: (_) {},
                            ),
                            Text("${pharmacy["distance"] ?? '1.2'} km away", style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                          ],
                        ),

                        SizedBox(height: 3.h),

                        Row(
                          children: [
                            Icon(Icons.location_on, color: const Color(0xFF339CFF), size: 18.sp),
                            SizedBox(width: 2.w),
                            Expanded(child: Text(pharmacy["address"] ?? "", style: GoogleFonts.inter(color: const Color(0xFF2E2E2E), fontSize: 13.sp))),
                          ],
                        ),

                        SizedBox(height: 4.h),

                        // Action Buttons + View Products
                        Row(
                          children: [
                            Expanded(child: RoundIconButton(title: "Call", icon: "assets/images/Location.png", color: const Color(0xFF339CFF), onPressed: () {})),
                            SizedBox(width: 3.w),
                            Expanded(child: RoundIconButton(title: "Directions", icon: "assets/images/Bookmark.png", color: const Color(0xFF339CFF), onPressed: () {})),
                          ],
                        ),

                        SizedBox(height: 4.h),

                        // View Products Card
                        GestureDetector(
                          onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AllProductsScreen(pharmacyId: pharmacyId))),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(color: const Color(0xFF339CFF).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Expanded(child: Text("Browse products from this pharmacy", style: GoogleFonts.inter(fontSize: 14.sp, color: const Color(0xFF0C141C)))),
                                const Icon(Icons.arrow_forward_ios, color: Color(0xFF339CFF)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Cart Button (Top Right)
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h, right: 5.w),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const CartScreen())),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.shopping_cart, size: 26, color: Colors.white),
                          // Cart count badge can be added later with provider
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => Scaffold(body: Center(child: Text("Failed to load pharmacy: $error"))),
      ),
    );
  }
}