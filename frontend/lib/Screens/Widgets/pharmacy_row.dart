// widgets/pharmacy_card.dart
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PharmacyRow extends StatelessWidget {
  final String name;
  final String address;
  final double rating;
  final String openUntil;
  final String imagePath;

  const PharmacyRow({
    super.key,
    required this.name,
    required this.address,
    required this.rating,
    required this.openUntil,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EDF4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text Column (Left)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: const Color(0xFF0C141C),
                    fontSize: 16.sp,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '$address · ${rating.toStringAsFixed(1)} stars · Open until $openUntil',
                  style: TextStyle(
                    color: const Color(0xFF4472A0),
                    fontSize: 14.sp,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: 4.w),

          // Image (Right)
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                height: 66,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 66,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_pharmacy, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}