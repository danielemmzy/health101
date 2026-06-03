// screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/features/auth/providers/order_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import 'track_order_screen.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

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
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.all(5.w),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
              SizedBox(height: 2.h),
              Text("Failed to load orders", style: GoogleFonts.inter(fontSize: 16.sp)),
              Text(err.toString(), style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey)),
            ],
          ),
        ),
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

  Widget _buildOrderCard(BuildContext context, dynamic order) {
    final isActive = order['status'] == "On the way" || order['status'] == "processing";

    return GestureDetector(
      onTap: isActive
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrackOrderScreen(orderId: order['id'].toString()),
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
          border: Border.all(
            color: isActive ? const Color(0xFF339CFF) : const Color(0xFFE5EDF4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['id'] ?? "ORD-XXXX",
                  style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2E2E2E)),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(DateTime.parse(order['created_at'])),
                  style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            // Product Images (first 3)
            SizedBox(
              height: 12.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: (order['items'] ?? []).length,
                separatorBuilder: (_, __) => SizedBox(width: 3.w),
                itemBuilder: (context, i) {
                  final item = order['items'][i];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item['image_url'] ?? "assets/images/placeholder.jpg",
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
                  "₦${(order['total_amount'] ?? 0).toStringAsFixed(1)}",
                  style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF339CFF)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF339CFF).withOpacity(0.15) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    order['status']?.toUpperCase() ?? "PENDING",
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