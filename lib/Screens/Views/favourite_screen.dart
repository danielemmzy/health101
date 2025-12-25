// screens/favourites_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Models/products.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'product_detailed_screen.dart'; // Make sure this exists

class FavouritesScreen extends StatelessWidget {
  FavouritesScreen({super.key});

  final List<Product> favouriteProducts = [
    Product(
      id: "fav1",
      imageCard: "assets/images/vitamin_c.jpg",
      imageDetail: "assets/images/vitamin_c.jpg",
      category: "Vitamins",
      name: "Vitamin C (Immune Support)",
      description: "Boost your immunity",
      rating: 4.9,
      price: 25.0,
      formerPrice: 32.0,
      isFavorite: true,
      deliveryTime: "15-20 min",
    ),
    Product(
      id: "fav2",
      imageCard: "assets/images/omega3.jpg",
      imageDetail: "assets/images/omega3.jpg",
      category: "Vitamins",
      name: "Omega-3 Fish Oil",
      description: "Heart & brain health",
      rating: 4.7,
      price: 30.0,
      formerPrice: 40.0,
      isFavorite: true,
      deliveryTime: "15-20 min",
    ),
    Product(
      id: "fav3",
      imageCard: "assets/images/calamine.jpg",
      imageDetail: "assets/images/calamine.jpg",
      category: "Personal Care",
      name: "Calamine Lotion",
      description: "Soothes skin irritation",
      rating: 4.8,
      price: 10.0,
      formerPrice: 14.0,
      isFavorite: true,
      deliveryTime: "15-20 min",
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: favouriteProducts.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              padding: EdgeInsets.all(5.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 3.h,
                childAspectRatio: 0.68,
              ),
              itemCount: favouriteProducts.length,
              itemBuilder: (context, index) {
                final product = favouriteProducts[index];
                return _buildProductCard(context, product, index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 70, color: Colors.grey[400]),
          SizedBox(height: 2.h),
          Text(
            "No favourites yet",
            style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            "Tap on any product to add to favourites",
            style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Reusable Product Card (same as your shop screen)
  Widget _buildProductCard(BuildContext context, Product product, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.asset(
                    product.imageCard,
                    height: 20.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite, color: Colors.red, size: 22.sp),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    product.name,
                    style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₦${product.price}",
                        style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF339CFF)),
                      ),
                      if (product.formerPrice != null)
                        Text(
                          "₦${product.formerPrice}",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}