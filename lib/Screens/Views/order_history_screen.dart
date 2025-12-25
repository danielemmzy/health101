// screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Models/products.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';


import 'track_order_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

  // 7 Realistic Orders using your actual products
  final List<Order> orders = [
    Order(
      id: "ORD-2025-0481",
      date: DateTime(2025, 4, 10),
      total: 68.0,
      status: "Delivered",
      items: [
        Product(
          id: "1",
          imageCard: "assets/images/ibuprofen.jpg",
          imageDetail: "assets/images/ibuprofen.jpg",
          category: "First Aid Essentials",
          name: "Ibuprofen (Advil)",
          description: "Fast pain relief",
          rating: 4.5,
          price: 15.0,
          formerPrice: 21.0,
          deliveryTime: "Delivered on Apr 11",
        ),
        Product(
          id: "2",
          imageCard: "assets/images/paracetamol.jpg",
          imageDetail: "assets/images/paracetamol.jpg",
          category: "First Aid Essentials",
          name: "Paracetamol (Tylenol)",
          description: "Fever & pain relief",
          rating: 4.6,
          price: 8.0,
          formerPrice: 12.0,
        ),
      ],
    ),
    Order(
      id: "ORD-2025-0479",
      date: DateTime(2025, 4, 8),
      total: 55.0,
      status: "On the way",
      items: [
        Product(
          id: "3",
          imageCard: "assets/images/vitamin_c.jpg",
          imageDetail: "assets/images/vitamin_c.jpg",
          category: "Vitamins",
          name: "Vitamin C (Immune Support)",
          description: "Boost your immunity",
          rating: 4.9,
          price: 25.0,
          formerPrice: 32.0,
        ),
        Product(
          id: "4",
          imageCard: "assets/images/omega3.jpg",
          imageDetail: "assets/images/omega3.jpg",
          category: "Vitamins",
          name: "Omega-3 Fish Oil",
          description: "Heart & brain health",
          rating: 4.7,
          price: 30.0,
          formerPrice: 40.0,
        ),
      ],
    ),
    Order(
      id: "ORD-2025-0475",
      date: DateTime(2025, 4, 5),
      total: 28.0,
      status: "Delivered",
      items: [
        Product(
          id: "5",
          imageCard: "assets/images/diclofenac.jpg",
          imageDetail: "assets/images/diclofenac.jpg",
          category: "First Aid Essentials",
          name: "Diclofenac Gel (Voltaren)",
          description: "Topical pain relief",
          rating: 4.6,
          price: 22.0,
          formerPrice: 28.0,
        ),
        Product(
          id: "6",
          imageCard: "assets/images/calamine.jpg",
          imageDetail: "assets/images/calamine.jpg",
          category: "Personal Care",
          name: "Calamine Lotion",
          description: "Soothes skin irritation",
          rating: 4.8,
          price: 10.0,
          formerPrice: 14.0,
        ),
      ],
    ),
    Order(
      id: "ORD-2025-0472",
      date: DateTime(2025, 4, 2),
      total: 18.0,
      status: "Delivered",
      items: [
        Product(
          id: "7",
          imageCard: "assets/images/ketoconazole.jpg",
          imageDetail: "assets/images/ketoconazole.jpg",
          category: "Personal Care",
          name: "Ketoconazole Cream",
          description: "Anti-fungal treatment",
          rating: 4.4,
          price: 18.0,
        ),
      ],
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
          "Order History",
          style: GoogleFonts.inter(fontSize: 19.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2E2E2E)),
        ),
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(5.w),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(context, order);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 3.h),
          Text("No orders yet", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          Text("Your orders will appear here", style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final isActive = order.status == "On the way";

    return GestureDetector(
      onTap: isActive
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrackOrderScreen(
                    orderId: order.id,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 3.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? const Color(0xFF339CFF) : const Color(0xFFE5EDF4), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: ID + Date + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2E2E2E)),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(order.date),
                  style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            // Product Images Row
            SizedBox(
              height: 12.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: order.items.length,
                separatorBuilder: (_, __) => SizedBox(width: 3.w),
                itemBuilder: (context, i) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      order.items[i].imageCard,
                      width: 12.h,
                      height: 12.h,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),

            // Total + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₦${order.total.toStringAsFixed(1)}",
                  style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF339CFF)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF339CFF).withOpacity(0.15) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    order.status,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isActive ? const Color(0xFF339CFF) : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),

            if (isActive) ...[
              SizedBox(height: 2.h),
              Center(
                child: Text(
                  "Tap to track delivery →",
                  style: GoogleFonts.inter(fontSize: 14.sp, color: const Color(0xFF339CFF), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Simple Order Model
class Order {
  final String id;
  final DateTime date;
  final double total;
  final String status;
  final List<Product> items;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });
}