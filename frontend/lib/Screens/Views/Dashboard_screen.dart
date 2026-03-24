import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/all_products_screen.dart';
import 'package:health101/Screens/Views/appointment.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:health101/Screens/Views/doctor_details_screen.dart';
import 'package:health101/Screens/Views/doctor_search.dart';
import 'package:health101/Screens/Views/featured_screen.dart';
import 'package:health101/Screens/Views/nearby_pharmacies_screen.dart';
import 'package:health101/Screens/Views/notification_screen.dart';
import 'package:health101/Screens/Views/popular_products_screen.dart';
import 'package:health101/Screens/Views/product_detailed_screen.dart';
import 'package:health101/Screens/Widgets/doctorss.dart';
import 'package:health101/Screens/Widgets/medicine_category_card.dart';
import 'package:health101/Screens/Widgets/pharmacy_card.dart';
import 'package:health101/Screens/Widgets/product_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:health101/Models/products.dart';



import '../Widgets/banner.dart';
import '../Widgets/list_doctor1.dart';
import '../Widgets/article.dart';
import 'find_doctor.dart';
import 'articlePage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedServiceIndex = 0; // Tracks clicked service
  

  final List<Map<String, dynamic>> services = [
    {"icon": Icons.child_care, "label": "Pediatrician"},
    {"icon": Icons.medication, "label": "Medicine"},
    {"icon": Icons.calendar_today, "label": "Book Visit"},
    {"icon": Icons.local_hospital, "label": "First Aid"},
    {"icon": Icons.lightbulb, "label": "Tips"},
    {"icon": Icons.question_answer, "label": "Ask Expert"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  toolbarHeight: 100,
  automaticallyImplyLeading: false, // Removes default back button
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // LEFT: LOGO + TITLE
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Image.asset(
              "assets/images/logo-green.png",
              height: 38,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12),
          
        ],
      ),

      // RIGHT: BELL + CART WITH BADGES
      Row(
        children: [
          // NOTIFICATION BELL WITH RED BADGE
          Padding(
            padding: EdgeInsets.only(top: 2.h, right: 4.w),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: NotificationScreen(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/bell.png",
                    width: 26,
                    height: 26,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        "3", // Change this dynamically later
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SHOPPING CART WITH RED BADGE
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: CartScreen(),
                  ),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        "7", // Change dynamically
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  ),
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
                readOnly: true,
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const find_doctor(),
                  ),
                ),
                decoration: InputDecoration(
                  hintText: "Search pharmacies, drugs, prescription...",
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey[600],
                  ),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Category Icons
            SizedBox(height: 3.h),

            // Banner
            const banner(),
            SizedBox(height: 3.h),

            // NEW: Health Services Section
            Text(
              "Health Services",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2E2E2E),
              ),
            ),
            SizedBox(height: 2.h),

           SizedBox(
  height: 100,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: services.length,
    itemBuilder: (context, index) {
      final service = services[index];
      final isSelected = index == selectedServiceIndex;

      return GestureDetector(
        onTap: () {
          setState(() {
            selectedServiceIndex = index;
          });

          // === NAVIGATION WITH PageTransition.rightToLeft ===
          switch (index) {
            case 0: // Pediatrician
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const find_doctor(), // ← Replace with your screen
                ),
              );
              break;

            case 1: // All Medicine
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const AllProductsScreen(),
                ),
              );
              break;

            case 2: // Book Visit
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const find_doctor(), // ← Replace with your screen
                ),
              );
              break;

            case 3: // First Aid
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: PopularProductsScreen(),
                ),
              );
              break;

            case 4: // Tips
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const articlePage(), // ← Replace with your screen
                ),
              );
              break;

            case 5: // Ask Expert
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const DoctorSearch(), // ← Replace with your screen
                ),
              );
              break;
          }
        },
        child: Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.transparent
                      : const Color.fromARGB(153, 236, 232, 232),
                  border: isSelected
                      ? Border.all(color: const Color(0xFF339CFF), width: 2)
                      : null,
                ),
                child: Icon(
                  service['icon'],
                  size: 28,
                  color: isSelected ? const Color(0xFF339CFF) : Colors.grey[700],
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                service['label'],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected ? const Color(0xFF339CFF) : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),
            // === FEATURED SECTION (before Top Doctors) ===
            SizedBox(height: 3.h),

            // Featured Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Featured",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: FeaturedScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "See more",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF339CFF),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Horizontal Scrollable Featured Cards
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  MedicineCategoryCard(
                    imagePath: "assets/images/summer_essentials.png",
                    title: "Summer Essentials",
                    description:
                        "Stay safe in the heat with our top summer tips and products",
                  ),
                  MedicineCategoryCard(
                    imagePath: "assets/images/immunity_boost.png",
                    title: "Immunity Boosters",
                    description:
                        "Top food and supplements for stronger immunity",
                  ),
                  MedicineCategoryCard(
                    imagePath: "assets/images/mental_wellness.png",
                    title: "Mental Wellness",
                    description:
                        "Prescriptions and medications to manage stress and improve your mindset",
                  ),
                  MedicineCategoryCard(
                    imagePath: "assets/images/first_aid.png",
                    title: "First Aid Basics",
                    description: "What to do in common health emergency",
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            // === NEARBY PHARMACIES SECTION ===
            SizedBox(height: 4.h),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nearby Pharmacies",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: NearbyPharmaciesScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "See all",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF339CFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Horizontal Scroll
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PharmacyCard(
                    imagePath: "assets/images/pharm1.png",
                    name: "Health101 Pharmacy",
                    address: "123 Main St, Anytown",
                    rating: 4.5,
                    openUntil: "9 PM",
                  ),
                  PharmacyCard(
                    imagePath: "assets/images/pharm2.png",
                    name: "Community Pharmacy",
                    address: "456 Oak Ave, Anytown",
                    rating: 4.2,
                    openUntil: "8 PM",
                  ),
                  PharmacyCard(
                    imagePath: "assets/images/pharm3.png",
                    name: "Wellness Pharmacy",
                    address: "789 Pine Ln, Anytown",
                    rating: 4.8,
                    openUntil: "10 PM",
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
             // Top Doctors List
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Doctors",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: DoctorSearch(),
                      ),
                    );
                  },
                  child: Text(
                    "See all",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF339CFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
SizedBox(
  height: 200,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: doctors.length,
    itemBuilder: (context, index) {
      final doc = doctors[index];
      return Padding(
        padding: EdgeInsets.only(right: 4.w),
        child: GestureDetector(
          onTap: () {
            // DYNAMIC NAVIGATION TO DOCTOR DETAILS
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: DoctorDetails(doctor: doc),
              ),
            );
          },
          child: list_doctor1(
            image: doc["image"]!,
            maintext: doc["name"]!,
            subtext: doc["specialty"]!,
            numRating: doc["rating"]!,
            distance: doc["distance"]!,
          ),
        ),
      );
    },
  ),
),

SizedBox(height: 3.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Products",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: PopularProductsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "See all",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF339CFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

           SizedBox(
  height: 410,
  child: GridView(
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 0.78,
    ),
    children: [
      ProductCard(
        imagePath: "assets/images/ibuprofen.jpg",
        category: "First Aid",
        name: "Ibuprofen (Advil)",
        description: "Fast pain relief",
        rating: 4.5,
        price: 15,
        formerPrice: 21,
        heroTag: "dash_0",
        onTap: () {
          final product = Product(
            id: "dash_0",
            imageCard: "assets/images/ibuprofen.jpg",
            imageDetail: "assets/images/ibuprofen.jpg",
            category: "First Aid",
            name: "Ibuprofen (Advil)",
            description: "Fast pain relief",
            rating: 4.5,
            price: 15,
            
          );
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: ProductDetailScreen(product: product),
            ),
          );
        },
      ),
      ProductCard(
        imagePath: "assets/images/vitamin_c.jpg",
        category: "Vitamins",
        name: "Vitamin C",
        description: "Immune support",
        rating: 4.9,
        price: 25,
        formerPrice: 32,
        heroTag: "dash_1",
        onTap: () {
          final product = Product(
            id: "dash_1",
            imageCard: "assets/images/vitamin_c.jpg",
            imageDetail: "assets/images/vitamin_c.jpg",
            category: "Vitamins",
            name: "Vitamin C",
            description: "Immune support",
            rating: 4.9,
            price: 25,
            
          );
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: ProductDetailScreen(product: product),
            ),
          );
        },
      ),
      ProductCard(
        imagePath: "assets/images/calamine.jpg",
        category: "Personal Care",
        name: "Calamine Lotion",
        description: "Soothes skin",
        rating: 4.8,
        price: 10,
        formerPrice: 14,
        heroTag: "dash_2",
        onTap: () {
          final product = Product(
            id: "dash_2",
            imageCard: "assets/images/calamine.jpg",
            imageDetail: "assets/images/calamine.jpg",
            category: "Personal Care",
            name: "Calamine Lotion",
            description: "Soothes skin",
            rating: 4.8,
            price: 10,
            
          );
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: ProductDetailScreen(product: product),
            ),
          );
        },
      ),
      ProductCard(
        imagePath: "assets/images/omega3.jpg",
        category: "Vitamins",
        name: "Omega-3 Fish Oil",
        description: "Heart health",
        rating: 4.7,
        price: 30,
        formerPrice: 40,
        heroTag: "dash_3",
        onTap: () {
          final product = Product(
            id: "dash_3",
            imageCard: "assets/images/omega3.jpg",
            imageDetail: "assets/images/omega3.jpg",
            category: "Vitamins",
            name: "Omega-3 Fish Oil",
            description: "Heart health",
            rating: 4.7,
            price: 30,
            
          );
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: ProductDetailScreen(product: product),
            ),
          );
        },
      ),
    ],
  ),
),
SizedBox(height: 4.h),

           

            // Health Articles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Health article",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const articlePage(),
                    ),
                  ),
                  child: Text(
                    "See all",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: const Color(0xFF339CFF),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            const article(
              image: "images/article1.png",
              dateText: "Jun 10, 2021",
              duration: "5min read",
              mainText:
                  "The 25 Healthiest Fruits You Can Eat,\nAccording to a Nutritionist",
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
