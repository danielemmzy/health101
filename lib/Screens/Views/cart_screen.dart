// screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/checkoutScreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Cart Items
  final List<Map<String, dynamic>> cartItems = [
    {
      "image": "assets/images/cough_syrup.jpg",
      "name": "Cough Syrup",
      "category": "Cold & Flu",
      "price": 12.99,
      "quantity": 1,
    },
    {
      "image": "assets/images/vitamin_c.jpg",
      "name": "Vitamin C",
      "category": "Vitamins",
      "price": 25.00,
      "quantity": 2,
    },
    {
      "image": "assets/images/ibuprofen.jpg",
      "name": "Ibuprofen",
      "category": "Pain Relief",
      "price": 15.00,
      "quantity": 1,
    },
  ];

  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(0, (sum, item) => sum + (item["price"] * item["quantity"]));
    const double shipping = 10.00;
    double total = subtotal + shipping;

    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF333333), size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Cart",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        
      ),
      body: Column(
        children: [
          // === CART ITEMS ===
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(5.w),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(
                  image: item['image'],
                  name: item["name"],
                  category: item["category"],
                  price: item["price"],
                  quantity: item["quantity"],
                  onDelete: () {
                    setState(() => cartItems.removeAt(index));
                  },
                  onQuantityChange: (newQty) {
                    setState(() => cartItems[index]["quantity"] = newQty);
                  },
                );
              },
            ),
          ),

          // === COUPON + SUMMARY ===
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
              ],
            ),
            child: Column(
              children: [
                // Coupon Code
                _buildCouponField(),
                SizedBox(height: 3.h),

                // Summary
                _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                _buildSummaryRow("Shipping", "\$10.00"),
                const Divider(height: 2, thickness: 1),
                _buildSummaryRow("Total", "\$${total.toStringAsFixed(2)}", isTotal: true),
                SizedBox(height: 3.h),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                     Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.bottomToTop, child: CheckoutScreen()),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF339CFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: Text(
                      "Proceed to Checkout",
                      style: GoogleFonts.lexend(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required String image,
    required String name,
    required String category,
    required double price,
    required int quantity,
    required VoidCallback onDelete,
    required Function(int) onQuantityChange,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: Colors.grey[300],
                child: const Icon(Icons.medication, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(width: 4.w),

          // Text Stack
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: GoogleFonts.lexend(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0C141C),
                    height: 1.5,
                  ),
                ),
                Text(
                  category,
                  style: GoogleFonts.lexend(
                    fontSize: 14.sp,
                    color: const Color(0xFF4472A0),
                    height: 1.5,
                  ),
                ),
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: GoogleFonts.lexend(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0C141C),
                  ),
                ),
              ],
            ),
          ),

          // Quantity + Delete
          Column(
            children: [
              // Quantity
              Row(
                children: [
                  _quantityButton(Icons.remove, () {
                    if (quantity > 1) onQuantityChange(quantity - 1);
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(
                      "$quantity",
                      style: GoogleFonts.lexend(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _quantityButton(Icons.add, () => onQuantityChange(quantity + 1)),
                ],
              ),
              SizedBox(height: 1.h),
              // Delete
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.delete_outline, color: Colors.red[400], size: 20.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5EDF4)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF4472A0)),
      ),
    );
  }

  Widget _buildCouponField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EDF4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: "Enter coupon code",
                hintStyle: GoogleFonts.lexend(fontSize: 14.sp, color: Colors.grey[600]),
                border: InputBorder.none,
              ),
            ),
          ),
          Text(
            "Apply",
            style: GoogleFonts.lexend(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF339CFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: isTotal ? 18.sp : 15.sp,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color: const Color(0xFF0C141C),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lexend(
              fontSize: isTotal ? 18.sp : 15.sp,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal ? const Color(0xFF339CFF) : const Color(0xFF0C141C),
            ),
          ),
        ],
      ),
    );
  }
}