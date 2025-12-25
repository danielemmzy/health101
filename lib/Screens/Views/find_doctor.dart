import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Widgets/pharmacy_row.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


// ignore: camel_case_types
class find_doctor extends StatelessWidget {
  const find_doctor({super.key});

  // Category Data
  final List<Map<String, String>> categories = const [
    {
      "title": "Prescriptions",
      "image": "assets/images/prescription.png",
    },
    {
      "title": "Over-the-Counter",
      "image": "assets/images/over_the_counter.png",
    },
    {
      "title": "Vitamins",
      "image": "assets/images/vitamins.png",
    },
    {
      "title": "Personal Care",
      "image": "assets/images/personal_care.png",
    },
    {
      "title": "First Aid",
      "image": "assets/images/first_aid.png",
    },
    {
      "title": "Wellness",
      "image": "assets/images/wellness.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SizedBox(
            height: 6.h,
            width: 6.w,
            child: Image.asset("assets/images/back2.png"),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Search Pharmacy",
          style: GoogleFonts.inter(
            color: const Color(0xFF0C141C),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search pharmacies, drugs, prescriptions...",
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
            SizedBox(height: 3.h),

            // === CATEGORIES SECTION ===
            Text(
              'Categories',
              style: TextStyle(
                color: const Color(0xFF0C141C),
                fontSize: 22.sp,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w700,
                height: 1.27,
              ),
            ),
            SizedBox(height: 2.h),

            // Grid of 2x3
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 3.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F9FC),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFCCDBEA)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(cat["image"]!),
                            fit: BoxFit.cover,
                            onError: (_, __) => const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          cat["title"]!,
                          style: TextStyle(
                            color: const Color(0xFF0C141C),
                            fontSize: 16.sp,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 4.h),

            // === NEARBY PHARMACIES ===
SizedBox(height: 1.h),

Text(
  'Nearby',
  style: TextStyle(
    color: const Color(0xFF0C141C),
    fontSize: 18.sp,
    fontFamily: 'Lexend',
    fontWeight: FontWeight.w700,
    height: 1.28,
  ),
),
// After Categories
SizedBox(height: 4.h),


Column(
  children: [
    PharmacyRow(
      name: "Health101 Pharmacy",
      address: "123 Main St, Anytown",
      rating: 4.5,
      openUntil: "9 PM",
      imagePath: "assets/images/pharm1.png",
    ),
    PharmacyRow(
      name: "Community Pharmacy",
      address: "456 Oak Ave, Anytown",
      rating: 4.2,
      openUntil: "8 PM",
      imagePath: "assets/images/pharm2.png",
    ),
    PharmacyRow(
      name: "Wellness Pharmacy",
      address: "789 Pine Ln, Anytown",
      rating: 4.8,
      openUntil: "10 PM",
      imagePath: "assets/images/pharm3.png",
    ),
  ],
),
SizedBox(height: 3.h),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDoctor(String name, String image) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0C141C),
          ),
        ),
      ],
    );
  }
}