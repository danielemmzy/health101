// screens/popular_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/product_detailed_screen.dart';
import 'package:health101/features/auth/providers/product_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/product_card.dart';

class PopularProductsScreen extends ConsumerWidget {
  const PopularProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);

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
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          return GridView.builder(
            padding: EdgeInsets.all(5.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 3.h,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index] as Map<String, dynamic>;

              return ProductCard(
                imagePath: product['image_url'] ?? 
                          product['thumbnail_url'] ?? 
                          "assets/images/placeholder.jpg",
                category: product['category']?.toString() ?? "",
                name: product['name'] ?? "Unknown Product",
                description: product['description'] ?? "",
                rating: (product['rating'] ?? 4.5).toDouble(),
                price: (product['price'] ?? 0.0).toDouble(),
                formerPrice: product['former_price']?.toDouble(),
                heroTag: "product_${product['id']}",
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
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Failed to load products"),
              Text(error.toString(), style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }
}