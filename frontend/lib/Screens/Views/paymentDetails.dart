// screens/payment_details.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/addCard.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

// Replace with your actual screens


class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  List<Map<String, dynamic>> cardArr = [
    {
      "icon": Icons.credit_card,
      "card": "**** **** **** 2187",
      "type": "Visa",
    }
  ];

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
          "Payment Details",
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
            Text(
              "Customize your payment method",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 16),
            Divider(color: Colors.grey.shade300, height: 1),

            SizedBox(height: 20),

            // PAYMENT METHODS CARD
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // CASH ON DELIVERY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cash/Card on Delivery",
                        style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                      ),
                      Icon(Icons.check_circle, color: Color(0xFF339CFF), size: 24),
                    ],
                  ),
                  Divider(height: 32, color: Colors.grey.shade300),

                  // SAVED CARDS
                  ...cardArr.map((card) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(card["icon"], color: Color(0xFF339CFF), size: 28),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    card["type"],
                                    style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    card["card"],
                                    style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 90,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade50,
                                  foregroundColor: Colors.red,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    cardArr.remove(card);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Card deleted")),
                                  );
                                },
                                child: Text("Delete", style: TextStyle(fontSize: 12.sp)),
                              ),
                            ),
                          ],
                        ),
                      )),

                  if (cardArr.isNotEmpty) Divider(height: 32, color: Colors.grey.shade300),

                  // OTHER METHODS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Other Methods",
                        style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // ADD CARD BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF339CFF),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                icon: Icon(Icons.add, color: Colors.white, size: 20),
                label: Text(
                  "Add Another Credit/Debit Card",
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(type: PageTransitionType.bottomToTop, child: AddCardScreen()),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}