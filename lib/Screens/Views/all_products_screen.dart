// screens/all_products_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../Views/Homepage.dart';
import '../Views/cart_screen.dart';
import '../widgets/product_card.dart';
import 'product_detailed_screen.dart';
import 'package:health101/Models/products.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";
  String _searchQuery = "";

  // FIXED: "assets/images/" + double values
  final List<Map<String, dynamic>> _rawProducts = [
    {
      "imagePath": "assets/images/ibuprofen.jpg",
      "category": "First Aid Essentials",
      "name": "Ibuprofen (Advil, Nurofen)",
      "description": "Fast relief for your health",
      "rating": 4.5,
      "price": 15.0,
      "formerPrice": 21.0,
    },
    {
      "imagePath": "assets/images/aspirin.jpg",
      "category": "First Aid Essentials",
      "name": "Aspirin (Bayer, Disprin)",
      "description": "Heart health & pain relief",
      "rating": 4.7,
      "price": 12.0,
      "formerPrice": 18.0,
    },
    {
      "imagePath": "assets/images/diclofenac.jpg",
      "category": "First Aid Essentials",
      "name": "Diclofenac Gel (Voltaren)",
      "description": "Topical pain relief",
      "rating": 4.6,
      "price": 22.0,
      "formerPrice": 28.0,
    },
    {
      "imagePath": "assets/images/ketoconazole.jpg",
      "category": "Personal Care",
      "name": "Ketoconazole Cream",
      "description": "Anti-fungal treatment",
      "rating": 4.4,
      "price": 18.0,
    },
    {
      "imagePath": "assets/images/calamine.jpg",
      "category": "Personal Care",
      "name": "Calamine Lotion",
      "description": "Soothes skin irritation",
      "rating": 4.8,
      "price": 10.0,
      "formerPrice": 14.0,
    },
    {
      "imagePath": "assets/images/vitamin_c.jpg",
      "category": "Vitamins",
      "name": "Vitamin C (Immune Support)",
      "description": "Boost your immunity",
      "rating": 4.9,
      "price": 25.0,
      "formerPrice": 32.0,
    },
    {
      "imagePath": "assets/images/omega3.jpg",
      "category": "Vitamins",
      "name": "Omega-3 Fish Oil",
      "description": "Heart & brain health",
      "rating": 4.7,
      "price": 30.0,
      "formerPrice": 40.0,
    },
    {
      "imagePath": "assets/images/paracetamol.jpg",
      "category": "First Aid Essentials",
      "name": "Paracetamol (Tylenol)",
      "description": "Fever & pain relief",
      "rating": 4.6,
      "price": 8.0,
      "formerPrice": 12.0,
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    return _rawProducts.where((p) {
      final matchesSearch = p["name"]
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          p["category"].toString().toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == "All" || p["category"] == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      "All",
      "First Aid Essentials",
      "Vitamins",
      "Personal Care"
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF333333), size: 26),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(type: PageTransitionType.fade, child: Homepage()),
                (route) => false,
              );
            }
          },
        ),
        title: Text(
          "All Products",
          style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Color(0xFF333333)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CartScreen())),
              child: Stack(
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
                  Positioned(
                    right: 0, top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text("7", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: EdgeInsets.all(5.w),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search, color: Color(0xFF339CFF)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
                fillColor: Color.fromARGB(255, 219, 236, 243),
              ),
            ),
          ),

          // CATEGORY FILTER
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
                      color: isSelected ? Color(0xFF339CFF) : Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : Color(0xFF2E2E2E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // PRODUCT GRID
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
                    child: Text(
                      "No products found",
                      style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(5.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.w,
                      mainAxisSpacing: 3.h,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = _filteredProducts[index];

                      return ProductCard(
                        imagePath: p["imagePath"],
                        category: p["category"],
                        name: p["name"],
                        description: p["description"],
                        rating: p["rating"] as double,
                        price: p["price"] as double,
                        formerPrice: p["formerPrice"] as double?,
                        heroTag: "all_$index",
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: ProductDetailScreen(
                                product: Product(
                                  id: "all_$index",
                                  imageCard: p["imagePath"],
                                  imageDetail: p["imagePath"],
                                  category: p["category"],
                                  name: p["name"],
                                  description: p["description"],
                                  rating: p["rating"] as double,
                                  price: p["price"] as double,
                                  formerPrice: p["formerPrice"] as double?,
                                  deliveryTime: "15-20 min",
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}