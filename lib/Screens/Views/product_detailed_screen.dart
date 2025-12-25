// screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Models/products.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


import '../widgets/round_icon_button.dart';
import 'cart_screen.dart'; // ← YOUR CART SCREEN

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int qty = 1;
  bool isFav = false;
  int cartCount = 3; // ← DYNAMIC CART COUNT (replace with provider or state)

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
            tag: widget.product.id,
            child: SizedBox(
              width: 100.w,
              height: 100.w,
              child: Image.asset(
                widget.product.imageDetail,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.medication, size: 20.w, color: Colors.grey),
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

                        // ────── TITLE ──────
                        Text(
                          widget.product.name,
                          style: GoogleFonts.inter(
                            color: primaryText,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),

                        // ────── RATING + PRICE ──────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IgnorePointer(
                                  ignoring: true,
                                  child: RatingBar.builder(
                                    initialRating: widget.product.rating,
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
                                  "${widget.product.rating} Stars",
                                  style: GoogleFonts.inter(
                                    color: primary,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    if (widget.product.formerPrice != null)
                                      Text(
                                        "\$${widget.product.formerPrice!.toStringAsFixed(0)}",
                                        style: GoogleFonts.inter(
                                          color: secondaryText,
                                          fontSize: 14.sp,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    if (widget.product.formerPrice != null) SizedBox(width: 1.w),
                                    Text(
                                      "\$${widget.product.price.toStringAsFixed(0)}",
                                      style: GoogleFonts.inter(
                                        color: primaryText,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "/per unit",
                                  style: GoogleFonts.inter(
                                    color: primaryText,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),

                        // ────── DESCRIPTION ──────
                        Text(
                          "Description",
                          style: GoogleFonts.inter(color: primaryText, fontSize: 14.sp, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          widget.product.description,
                          style: GoogleFonts.inter(color: secondaryText, fontSize: 13.sp, height: 1.5),
                        ),
                        SizedBox(height: 3.h),

                        Divider(color: secondaryText.withOpacity(0.3), height: 1),
                        SizedBox(height: 3.h),

                        // ────── QUANTITY ──────
                        Row(
                          children: [
                            Text(
                              "Number of Units",
                              style: GoogleFonts.inter(color: primaryText, fontSize: 14.sp, fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            _qtyButton("-", () => setState(() => qty = qty > 1 ? qty - 1 : 1)),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              height: 6.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(border: Border.all(color: primary), borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                qty.toString(),
                                style: GoogleFonts.inter(color: primary, fontSize: 14.sp, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            _qtyButton("+", () => setState(() => qty++)),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // ────── TOTAL PRICE CARD ──────
                        SizedBox(
                          height: 38.h,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: 20.w,
                                height: 33.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E2E2E),
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
                                    boxShadow: [BoxShadow(color: Color(0xFF2E2E2E), blurRadius: 12, offset: Offset(0, 4))],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total Price",
                                        style: GoogleFonts.inter(color: primaryText, fontSize: 12.sp, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "\$${(widget.product.price * qty).toStringAsFixed(0)}",
                                        style: GoogleFonts.inter(color: primaryText, fontSize: 20.sp, fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 3.h),
                                      RoundIconButton(
                                        title: "Add to Cart",
                                        icon: "assets/images/shopping_add.png",
                                        color: const Color(0xFF2E2E2E),
                                        onPressed: () {
                                          setState(() => cartCount++); // ← UPDATE CART COUNT
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("${widget.product.name} × $qty added!"), backgroundColor: primary),
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
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(color: white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                                    child: Image.asset("assets/images/shopping_cart.png", width: 1.w, height: 1.w, color: primary),
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
                width: 10.w,
                height: 10.w,
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
                  // BACK BUTTON
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Image.asset("assets/images/btn_back.png", width: 6.w, height: 6.w, color: white),
                  ),

                  // CART WITH BADGE
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
                        Icon(Icons.shopping_cart, size: 23, color: white),
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

  Widget _qtyButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 8.w,
        height: 8.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: GoogleFonts.inter(color: white, fontSize: 16.sp, fontWeight: FontWeight.w700)),
      ),
    );
  }
}