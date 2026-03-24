// screens/popular_products_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../widgets/product_card.dart';
import 'product_detailed_screen.dart';
import 'package:health101/Models/products.dart';

class PopularProductsScreen extends StatelessWidget {
  PopularProductsScreen({super.key});

  // FIXED: ALL PATHS CORRECT + NO TYPO
  final List<Map<String, dynamic>> _rawProducts = [
    {
      "imagePath": "assets/images/ibuprofen.jpg", // FIXED: assets (not assests)
      "category": "First Aid Essentials",
      "name": "Ibuprofen (Advil, Nurofen)",
      "description": "Fast relief for your health",
      "rating": 4.5,     // double
      "price": 15.0,     // double
      "formerPrice": 21.0, // double
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

  List<Product> get products {
    return _rawProducts.asMap().entries.map((entry) {
      final p = entry.value;
      return Product(
        id: "pop_${entry.key}",
        imageCard: p["imagePath"],
        imageDetail: p["imagePath"],
        name: p["name"],
        category: p["category"],
        description: p["description"],
        price: p["price"] as double,           // double
        rating: p["rating"] as double,         // double
        formerPrice: p["formerPrice"] as double?, // nullable
        deliveryTime: "15-20 min",
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Popular Products",
          style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(5.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 3.h,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final raw = _rawProducts[index];

          return ProductCard(
            imagePath: raw["imagePath"], // CORRECT PATH
            category: raw["category"],
            name: raw["name"],
            description: raw["description"],
            rating: raw["rating"] as double,
            price: raw["price"] as double,
            formerPrice: raw["formerPrice"] as double?,
            heroTag: product.id,
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}