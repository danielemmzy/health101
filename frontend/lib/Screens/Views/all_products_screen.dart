import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/features/auth/providers/product_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Views/Homepage.dart';
import '../Views/cart_screen.dart';
import '../widgets/product_card.dart';
import 'product_detailed_screen.dart';

class AllProductsScreen extends ConsumerStatefulWidget {
  final int? pharmacyId;   // Optional

  const AllProductsScreen({super.key, this.pharmacyId});

  @override
  ConsumerState<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends ConsumerState<AllProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final productsAsync = widget.pharmacyId != null
        ? ref.watch(productsByPharmacyProvider(widget.pharmacyId!))
        : ref.watch(allProductsProvider);   // ← All products

    final categories = ["All", "First Aid Essentials", "Vitamins", "Personal Care", "Others"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF333333), size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.pharmacyId == null ? "All Products" : "Pharmacy Products",
          style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF333333)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                PageTransition(type: PageTransitionType.rightToLeft, child: const CartScreen()),
              ),
              child: const Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(5.w),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF339CFF)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
                fillColor: const Color.fromARGB(255, 219, 236, 243),
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final cat = categories[i];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF339CFF) : const Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : const Color(0xFF2E2E2E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Products Grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final filtered = products.where((p) {
                  final matchesSearch = _searchQuery.isEmpty ||
                      p["name"].toString().toLowerCase().contains(_searchQuery.toLowerCase());

                  final matchesCategory = _selectedCategory == "All" || p["category"] == _selectedCategory;

                  return matchesSearch && matchesCategory;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                return GridView.builder(
                  padding: EdgeInsets.all(5.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.w,
                    mainAxisSpacing: 3.h,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final p = filtered[index];
                    return ProductCard(
                      imagePath: p["image_url"] ?? "assets/images/placeholder.jpg",
                      category: p["category"] ?? "",
                      name: p["name"] ?? "",
                      description: p["description"] ?? "",
                      rating: (p["rating"] ?? 4.5).toDouble(),
                      price: (p["price"] ?? 0.0).toDouble(),
                      formerPrice: p["former_price"]?.toDouble(),
                      heroTag: "product_${p['id']}",
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: ProductDetailScreen(product: p),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text("Failed to load products: $error")),
            ),
          ),
        ],
      ),
    );
  }
}