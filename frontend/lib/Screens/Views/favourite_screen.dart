// screens/favourites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/product_detailed_screen.dart';
import 'package:health101/features/auth/providers/favourite_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../widgets/product_card.dart';


class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesAsync = ref.watch(favouritesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("assets/images/back2.png", width: 28, height: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Favourites",
          style: GoogleFonts.inter(fontSize: 19.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: favouritesAsync.when(
        data: (favourites) {
          if (favourites.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            padding: EdgeInsets.all(5.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 3.h,
              childAspectRatio: 0.68,
            ),
            itemCount: favourites.length,
            itemBuilder: (context, index) {
              final product = favourites[index];

              return ProductCard(
                imagePath: product['image_url'] ?? product['thumbnail_url'] ?? "assets/images/placeholder.jpg",
                category: product['category']?.toString() ?? "",
                name: product['name'] ?? "Unknown Product",
                description: product['description'] ?? "",
                rating: (product['rating'] ?? 4.5).toDouble(),
                price: (product['price'] ?? 0.0).toDouble(),
                formerPrice: product['former_price']?.toDouble(),
                heroTag: "fav_${product['id']}",                    // ← Always true here
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
        error: (_, __) => const Center(child: Text("Failed to load favourites")),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          SizedBox(height: 3.h),
          Text(
            "No favourites yet",
            style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          Text(
            "Tap ❤️ on any product to add here",
            style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}