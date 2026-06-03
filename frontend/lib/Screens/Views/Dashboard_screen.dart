// screens/dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/product_detailed_screen.dart';
import 'package:health101/features/auth/providers/product_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Widgets/banner.dart';
import '../Widgets/list_doctor1.dart';
import '../Widgets/article.dart';
import '../Widgets/medicine_category_card.dart';
import '../Widgets/pharmacy_card.dart';
import '../Widgets/product_card.dart';

import 'find_doctor.dart';
import 'articlePage.dart';
import 'all_products_screen.dart';
import 'appointment.dart';
import 'cart_screen.dart';
import 'doctor_details_screen.dart';
import 'doctor_search.dart';
import 'featured_screen.dart';
import 'nearby_pharmacies_screen.dart';
import 'notification_screen.dart';
import 'popular_products_screen.dart';
import '../../features/auth/providers/cart_provider.dart';
import '../../features/auth/providers/doctor_provider.dart';
import '../../features/auth/providers/pharmacy_provider.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  int selectedServiceIndex = 0;

  final List<Map<String, dynamic>> services = [
    {"icon": Icons.child_care, "label": "Pediatrician"},
    {"icon": Icons.medication, "label": "Medicine"},
    {"icon": Icons.calendar_today, "label": "Book Visit"},
    {"icon": Icons.local_hospital, "label": "First Aid"},
    {"icon": Icons.lightbulb, "label": "Tips"},
    {"icon": Icons.question_answer, "label": "Ask Expert"},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartCountProvider.notifier).fetchCartCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Image.asset("assets/images/logo-green.png", height: 38),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h, right: 4.w),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child:  NotificationScreen())),
                    child: Stack(
                      children: [
                        Image.asset("assets/images/bell.png", width: 26, height: 26),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: const Text("3", style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const CartScreen())),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
                        if (cartCount > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
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
              decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12)),
              child: TextField(
                readOnly: true,
                onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const find_doctor())),
                decoration: InputDecoration(
                  hintText: "Search pharmacies, drugs, prescription...",
                  hintStyle: TextStyle(fontSize: 15.sp, color: Colors.grey[600]),
                  prefixIcon: Padding(padding: const EdgeInsets.all(12), child: Image.asset("assets/images/search.png", width: 20, height: 20, color: const Color(0xFF339CFF))),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Services (your original)
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
                      setState(() => selectedServiceIndex = index);
                      // your navigation logic...
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
                              color: isSelected ? Colors.transparent : const Color.fromARGB(153, 236, 232, 232),
                              border: isSelected ? Border.all(color: const Color(0xFF339CFF), width: 2) : null,
                            ),
                            child: Icon(service['icon'], size: 28, color: isSelected ? const Color(0xFF339CFF) : Colors.grey[700]),
                          ),
                          SizedBox(height: 1.h),
                          Text(service['label'], style: TextStyle(fontSize: 12.sp, color: isSelected ? const Color(0xFF339CFF) : Colors.grey[700])),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 3.h),
            const banner(),
            SizedBox(height: 3.h),

            // === YOUR ORIGINAL POPULAR PRODUCTS SECTION (Only this part is dynamic now) ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Products",
                  style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2E2E2E)),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const PopularProductsScreen())),
                  child: Text("See all", style: GoogleFonts.inter(fontSize: 14.sp, color: const Color(0xFF339CFF), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // **Dynamic GridView** (Only this part changed)
            SizedBox(
              height: 410,
              child: ref.watch(allProductsProvider).when(
                data: (products) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: products.length > 4 ? 4 : products.length,
                    itemBuilder: (context, index) {
                      final product = products[index] as Map<String, dynamic>;

                      return ProductCard(
                        imagePath: product['image_url'] ?? "assets/images/placeholder.jpg",
                        category: product['category']?.toString() ?? "",
                        name: product['name'] ?? "Unknown Product",
                        description: product['description'] ?? "",
                        rating: (product['rating'] ?? 4.5).toDouble(),
                        price: (product['price'] ?? 0.0).toDouble(),
                        formerPrice: product['former_price']?.toDouble(),
                        heroTag: "dash_${product['id']}",
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: ProductDetailScreen(productId: product['id']),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text("Failed to load products")),
              ),
            ),

            SizedBox(height: 4.h),

            // === Rest of your original code remains unchanged ===
            // Top Doctors, Nearby Pharmacies, Articles, etc.

            // ... (your original code from here continues)

          ],
        ),
      ),
    );
  }
}