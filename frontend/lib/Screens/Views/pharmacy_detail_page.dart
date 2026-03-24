// screens/pharmacy_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Models/pharmacy.dart';
import 'package:health101/Screens/Views/all_products_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


import '../widgets/round_icon_button.dart';
import 'cart_screen.dart'; // ← YOUR CART SCREEN

class PharmacyDetailScreen extends StatefulWidget {
  final Pharmacy pharmacy;
  const PharmacyDetailScreen({super.key, required this.pharmacy});

  @override
  State<PharmacyDetailScreen> createState() => _PharmacyDetailScreenState();
}

class _PharmacyDetailScreenState extends State<PharmacyDetailScreen> {
  bool isFav = false;
  int cartCount = 7; // ← DYNAMIC CART COUNT

  // ────── YOUR COLORS ──────
  static const Color primary = Color(0xFF339CFF);
  static const Color white = Colors.white;
  static const Color primaryText = Color(0xFF0C141C);
  static const Color secondaryText = Color(0xFF2E2E2E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ────── HERO IMAGE + GRADIENT ──────
          Hero(
            tag: widget.pharmacy.id,
            child: SizedBox(
              width: 100.w,
              height: 100.w,
              child: Image.asset(
                widget.pharmacy.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.local_pharmacy, size: 20.w, color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            width: 100.w,
            height: 100.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ────── SCROLLABLE CONTENT ──────
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 100.w - 8.h),
            child: Column(
              children: [
                Container(
                  width: 100.w,
                  decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),

                        // ────── NAME ──────
                        Text(
                          widget.pharmacy.name,
                          style: GoogleFonts.inter(
                            color: primaryText,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),

                        // ────── RATING + DISTANCE ──────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IgnorePointer(
                                  ignoring: true,
                                  child: RatingBar.builder(
                                    initialRating: widget.pharmacy.rating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 16.sp,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 0.5.w),
                                    itemBuilder: (_, __) => const Icon(Icons.star, color: primary),
                                    onRatingUpdate: (_) {},
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  "${widget.pharmacy.rating} Stars",
                                  style: GoogleFonts.inter(color: primary, fontSize: 11.sp, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Text(
                              "${widget.pharmacy.distance} km away",
                              style: GoogleFonts.inter(color: primaryText, fontSize: 14.sp, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),

                        // ────── ADDRESS ──────
                        Row(
                          children: [
                            Icon(Icons.location_on, color: primary, size: 18.sp),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                widget.pharmacy.address,
                                style: GoogleFonts.inter(color: secondaryText, fontSize: 13.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),

                        // ────── OPEN UNTIL BADGE ──────
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primary.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, color: primary, size: 16.sp),
                              SizedBox(width: 1.w),
                              Text(
                                "Open until ${widget.pharmacy.openUntil}",
                                style: GoogleFonts.inter(color: primary, fontSize: 12.sp, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),

                        Divider(color: secondaryText.withOpacity(0.3), height: 1),
                        SizedBox(height: 3.h),

                        // ────── ACTION BUTTONS ──────
                        Row(
                          children: [
                            Expanded(
                              child: RoundIconButton(
                                title: "Call",
                                icon: "assets/images/Location.png",
                                color: primary,
                                onPressed: () {
                                  // TODO: Launch phone
                                },
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: RoundIconButton(
                                title: "Directions",
                                icon: "assets/images/Bookmark.png",
                                color: primary,
                                onPressed: () {
                                  // TODO: Open maps
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // ────── TOTAL PRICE CARD (REUSED FOR "ORDER NOW") ──────
                        SizedBox(
                          height: 38.h,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: 25.w,
                                height: 38.h,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(35), bottomRight: Radius.circular(35)),
                                ),
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h, bottom: 2.h),
                                  width: 80.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Ready to Order?",
                                        style: GoogleFonts.inter(color: primaryText, fontSize: 14.sp, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "Browse products from this pharmacy",
                                        style: GoogleFonts.inter(color: secondaryText, fontSize: 12.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 3.h),
                                      RoundIconButton(
                                        title: "View Products",
                                        icon: "assets/images/shopping_add.png",
                                        color: primary,
                                        onPressed: () {
                                          Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child: AllProductsScreen()),
                );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 8.w,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(type: PageTransitionType.rightToLeft, child: const CartScreen()),
                                    );
                                  },
                                  child: Container(
                                    width: 12.w,
                                    height: 12.w,
                                    decoration: BoxDecoration(color: white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                                    child: Image.asset("assets/images/shopping_cart.png", width: 6.w, height: 6.w, color: primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ────── FAVORITE BUTTON ──────
          Positioned(
            bottom: 100.w - 20.h,
            right: 4.w,
            child: InkWell(
              onTap: () => setState(() => isFav = !isFav),
              child: Image.asset(
                isFav ? "assets/images/favorites_btn.png" : "assets/images/favorites_btn_2.png",
                width: 18.w,
                height: 18.w,
              ),
            ),
          ),

          // ────── TOP BAR: BACK + CART BADGE ──────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Image.asset("assets/images/btn_back.png", width: 6.w, height: 6.w, color: white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(type: PageTransitionType.rightToLeft, child: const CartScreen()),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.shopping_cart, size: 26, color: white),
                        if (cartCount > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                cartCount.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}