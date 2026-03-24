// widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductCard extends StatefulWidget {
  final String imagePath;
  final String category;
  final String name;
  final String description;
  final double rating;
  final double price;
  final double? formerPrice;
  final VoidCallback? onTap;        // ← ADDED
  final String heroTag;             // ← ADDED

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.name,
    required this.description,
    required this.rating,
    required this.price,
    this.formerPrice,
    this.onTap,
    required this.heroTag,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 200,
        margin: EdgeInsets.only(right: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Hero(
                    tag: widget.heroTag,
                    child: Image.asset(
                      widget.imagePath,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Icon(Icons.medication, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${widget.price.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.formerPrice != null)
                              Text(
                                '\$${widget.formerPrice!.toStringAsFixed(0)}',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 1.w),
                            Text(
                              widget.rating.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 14.sp),
                            ),
                            SizedBox(width: 2.w),
                            GestureDetector(
                              onTap: () => setState(() => isFavorite = !isFavorite),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              widget.category,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              widget.name,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E2E2E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              widget.description,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}