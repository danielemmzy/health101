// screens/featured_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Widgets/medicine_category_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class FeaturedScreen extends StatelessWidget {
  FeaturedScreen({super.key});

  final List<MedicineCategoryCard> allCategories = [
    MedicineCategoryCard(
      imagePath: "assets/images/summer_essentials.png",
      title: "Summer Essentials",
      description: "Stay safe in the heat with our top summer tips and products",
    ),
    MedicineCategoryCard(
      imagePath: "assets/images/immunity_boost.png",
      title: "Immunity Boosters",
      description: "Top food and supplements for stronger immunity",
    ),
    MedicineCategoryCard(
      imagePath: "assets/images/mental_wellness.png",
      title: "Mental Wellness",
      description: "Prescriptions and medications to manage stress and improve your mindset",
    ),
    MedicineCategoryCard(
      imagePath: "assets/images/first_aid.png",
      title: "First Aid Basics",
      description: "What to do in common health emergency",
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
          "Featured",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E2E2E),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: GridView.builder(
          padding: EdgeInsets.only(top: 2.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 3.h,
            childAspectRatio: 0.78,
          ),
          itemCount: allCategories.length,
          itemBuilder: (context, index) {
            final cat = allCategories[index];
            return GestureDetector(
              onTap: () {
                // PLACEHOLDER: Open detail
                print("${cat.title} clicked");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        cat.imagePath,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat.title,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E2E2E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            cat.description,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: Colors.grey[700],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}