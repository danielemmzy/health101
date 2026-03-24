// screens/appointment_booked_message_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Login-Signup/shedule_screen.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

// Replace with your actual screens
// or main dashboard

class AppointmentBookedMessageScreen extends StatelessWidget {
  const AppointmentBookedMessageScreen({super.key});

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

          // DOCTOR SUCCESS ICON
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFF339CFF).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_hospital,
              color: Color(0xFF339CFF),
              size: 56,
            ),
          ),

          SizedBox(height: 28),

          // TITLE
          Text(
            "Appointment Booked!",
            style: GoogleFonts.inter(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "See you soon",
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
              "Your appointment has been successfully scheduled. You'll receive a confirmation via SMS and email. You can view details and join the video call from your appointments.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                color: Color(0xFF666666),
                height: 1.6,
              ),
            ),
          ),

          SizedBox(height: 36),

          // VIEW APPOINTMENT BUTTON
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: ScheduleScreen(), // Your appointments list
                  ),
                );
              },
              child: Text(
                "View Appointment",
                style: GoogleFonts.inter(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          SizedBox(height: 12),

          // BACK TO HOME
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(type: PageTransitionType.fade, child: Homepage()),
                (route) => false,
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