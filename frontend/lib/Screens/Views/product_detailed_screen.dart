// screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/features/auth/providers/cart_provider.dart';
import 'package:health101/features/auth/providers/cart_provider.dart' as cart;
import 'package:health101/features/auth/providers/product_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/round_icon_button.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final int productId; // ← Pass ID instead of full object

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int qty = 1;
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: productAsync.when(
        data: (product) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // Hero Image
              Hero(
                tag: "product_${widget.productId}",
                child: SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: Image.network(
                    product['image_url'] ?? product['thumbnail_url'] ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.medication,
                        size: 20.w,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Scrollable Content
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 100.w - 8.h),
                child: Column(
                  children: [
                    Container(
                      width: 100.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 4.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0C141C),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 1.h),

                            // Rating + Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBar.builder(
                                  initialRating: (product['rating'] ?? 4.5)
                                      .toDouble(),
                                  minRating: 1,
                                  itemCount: 5,
                                  itemSize: 16.sp,
                                  ignoreGestures: true,
                                  itemBuilder: (_, __) => const Icon(
                                    Icons.star,
                                    color: Color(0xFF339CFF),
                                  ),
                                  onRatingUpdate: (_) {},
                                ),
                                Text(
                                  "\$${product['price'].toStringAsFixed(2)}",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0C141C),
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 3.h),

                            Text(
                              "Description",
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              product['description'] ??
                                  "No description available.",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 4.h),

                            // Quantity
                            Row(
                              children: [
                                Text(
                                  "Quantity",
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                _qtyButton(
                                  "-",
                                  () => setState(
                                    () => qty = qty > 1 ? qty - 1 : 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Text(
                                    "$qty",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                _qtyButton("+", () => setState(() => qty++)),
                              ],
                            ),

                            SizedBox(height: 4.h),

                            // Add to Cart Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF339CFF),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    await ref.read(
                                      cart.addToCartProvider({
                                        'productId': widget.productId,
                                        'quantity': qty,
                                      }).future,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${product['name']} × $qty added to cart!",
                                        ),
                                        backgroundColor: const Color(
                                          0xFF339CFF,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Failed to add to cart"),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Add to Cart",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Back Button
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h, left: 5.w),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Image.asset(
                      "assets/images/btn_back.png",
                      width: 6.w,
                      height: 6.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Failed to load product")),
      ),
    );
  }

  Widget _qtyButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 8.w,
        height: 8.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF339CFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
