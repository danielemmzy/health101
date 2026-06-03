import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/checkoutScreen.dart';
import 'package:health101/features/auth/providers/cart_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';


class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch cart on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartCountProvider.notifier).fetchCartCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider); // We'll create this provider

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333), size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Cart",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF333333),
          ),
        ),
        centerTitle: true,
      ),
      body: cartAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return _buildEmptyCart();
          }

          double subtotal = cartItems.fold(0.0, (sum, item) {
            return sum + (item['price'] * item['quantity']);
          });
          const double shipping = 10.00;
          double total = subtotal + shipping;

          return Column(
            children: [
              // Cart Items
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(5.w),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return _buildCartItem(item, index);
                  },
                ),
              ),

              // Coupon + Summary
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                ),
                child: Column(
                  children: [
                    _buildCouponField(),
                    SizedBox(height: 3.h),
                    _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                    _buildSummaryRow("Shipping", "\$10.00"),
                    const Divider(height: 2, thickness: 1),
                    _buildSummaryRow("Total", "\$${total.toStringAsFixed(2)}", isTotal: true),
                    SizedBox(height: 3.h),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF339CFF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          "Proceed to Checkout",
                          style: GoogleFonts.lexend(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Failed to load cart")),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['image_url'] ?? "assets/images/placeholder.jpg",
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.medication, color: Colors.grey),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] ?? "", style: GoogleFonts.lexend(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                Text(item['category'] ?? "", style: GoogleFonts.lexend(fontSize: 13.sp, color: Colors.grey)),
                Text("\$${(item['price'] ?? 0.0).toStringAsFixed(2)}", style: GoogleFonts.lexend(fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _quantityButton(Icons.remove, () {
                    // TODO: Update quantity in backend
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text("${item['quantity']}", style: GoogleFonts.lexend(fontSize: 15.sp)),
                  ),
                  _quantityButton(Icons.add, () {
                    // TODO: Update quantity in backend
                  }),
                ],
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () {
                  // TODO: Remove from cart
                },
                child: Icon(Icons.delete_outline, color: Colors.red[400], size: 22),
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
          GestureDetector(
            onTap: () {
              // TODO: Apply coupon logic
            },
            child: Text(
              "Apply",
              style: GoogleFonts.lexend(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF339CFF)),
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
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lexend(
              fontSize: isTotal ? 18.sp : 15.sp,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal ? const Color(0xFF339CFF) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 3.h),
          Text("Your cart is empty", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          Text("Start adding products", style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
        ],
      ),
    );
  }
}