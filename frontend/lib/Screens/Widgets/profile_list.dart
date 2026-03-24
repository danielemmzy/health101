// widgets/profile_list.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileList extends StatelessWidget {
  final String image;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const ProfileList({
    super.key,
    required this.image,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(image, width: 7.w, height: 7.w),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15.sp,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
    );
  }
}
