// screens/checkout_message_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:health101/Screens/Views/track_order_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

// Replace with your actual screens


class CheckoutMessageScreen extends StatelessWidget {
  const CheckoutMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Container(
      width: media.width,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(0, -10)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CLOSE BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Color(0xFF333333), size: 26),
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(),
              ),
            ],
          ),

          SizedBox(height: 16),

          // SUCCESS ICON
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFF339CFF).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Color(0xFF339CFF),
              size: 60,
            ),
          ),

          SizedBox(height: 28),

          // TITLE
          Text(
            "Thank You!",
            style: GoogleFonts.inter(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "for your order",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),

          SizedBox(height: 24),

          // MESSAGE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Your order is now being processed. We will notify you once it's picked up from the pharmacy. You can track your order in real-time.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                color: Color(0xFF666666),
                height: 1.6,
              ),
            ),
          ),

          SizedBox(height: 36),

          // TRACK ORDER BUTTON
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
                
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child:TrackOrderScreen(orderId: "ORD-2025-0991",)),
                );
              },
              child: Text(
                "Track My Order",
                style: GoogleFonts.inter(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          SizedBox(height: 12),

          // BACK TO HOME
          TextButton(
            onPressed: () {
              
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child:Homepage()),
                );
            },
            child: Text(
              "Back to Home",
              style: GoogleFonts.inter(
                color: Color(0xFF339CFF),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}