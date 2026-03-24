// screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Login-Signup/enable_location.dart';
import 'package:health101/Screens/Views/addCard.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:health101/Screens/Views/checkoutMessage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

// Replace with your actual screens


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<Map<String, dynamic>> paymentMethods = [
    {"name": "Cash on Delivery", "icon": Icons.payments},
    {"name": "**** **** **** 2187", "icon": Icons.credit_card},
    {"name": "test@gmail.com", "icon": Icons.paypal},
  ];

  int selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
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
          "Checkout",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child: CartScreen()),
                );
              },
              child: Stack(
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        "7",
                        style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DELIVERY ADDRESS
            Text(
              "Delivery Address",
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "653 Nostrand Ave.",
                        style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                      ),
                      Text(
                        "Brooklyn, NY 11216",
                        style: GoogleFonts.inter(fontSize: 14.sp, color: Color(0xFF666666)),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.bottomToTop, child: EnableLocation()),
                    );
                  },
                  child: Text(
                    "Change",
                    style: GoogleFonts.inter(color: Color(0xFF339CFF), fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(height: 1, color: Colors.grey.shade300),

            SizedBox(height: 24),

            // PAYMENT METHOD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment Method",
                  style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.bottomToTop, child: AddCardScreen()),
                    );
                  },
                  icon: Icon(Icons.add, color: Color(0xFF339CFF), size: 18),
                  label: Text(
                    "Add Card",
                    style: GoogleFonts.inter(color: Color(0xFF339CFF), fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // PAYMENT OPTIONS
            ...paymentMethods.asMap().entries.map((entry) {
              int index = entry.key;
              var method = entry.value;

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: selectedMethod == index ? Color(0xFF339CFF) : Colors.transparent, width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2)),
                  ],
                ),
                child: InkWell(
                  onTap: () => setState(() => selectedMethod = index),
                  child: Row(
                    children: [
                      Icon(method["icon"], color: Color(0xFF339CFF), size: 26),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          method["name"],
                          style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
                        ),
                      ),
                      Icon(
                        selectedMethod == index ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: Color(0xFF339CFF),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            SizedBox(height: 24),
            Divider(height: 1, color: Colors.grey.shade300),

            SizedBox(height: 20),

            // PRICE BREAKDOWN
            _buildPriceRow("Sub Total", "\$68"),
            _buildPriceRow("Delivery Cost", "\$2"),
            _buildPriceRow("Discount", "-\$4", isDiscount: true),
            SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade400),
            SizedBox(height: 16),
            _buildPriceRow("Total", "\$66", isTotal: true),

            SizedBox(height: 32),

            // SEND ORDER BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF339CFF),
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 4,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CheckoutMessageScreen(),
                  );
                },
                child: Text(
                  "Send Order",
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 18.sp : 15.sp,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isDiscount ? Colors.red.shade600 : Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}