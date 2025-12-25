// screens/appointment_details_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';
import '../Views/chat_screen.dart'; // Import your chat screen

class AppointmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final doctor = appointment["doctor"] as Map<String, String>;

    // Build doctor data for chat
    final Map<String, dynamic> doctorChatData = {
      "id": doctor["id"] ?? 999,
      "image": doctor["image"]!,
      "name": doctor["name"]!,
      "specialty": doctor["specialty"]!,
      "lastMessage": "Hello, how can I help you today?",
      "time": "Now",
      "unreadCount": 0,
      "messages": [
        {"text": "Hello! Your consultations is confirmed.", "isUser": false, "time": "Just now"},
      ],
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text("Consultations", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            // Doctor Card
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(doctor["image"]!, width: 80, height: 80, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor["name"]!, style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                      Text(doctor["specialty"]!, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14.sp)),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Text(" 4.8", style: GoogleFonts.inter(fontSize: 14.sp)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Details
            _buildDetailRow(Icons.calendar_today, "Date", appointment["date"]),
            _buildDetailRow(Icons.access_time, "Time", appointment["time"]),
            _buildDetailRow(Icons.medical_services, "Type", appointment["type"] ?? "In-person"),
            _buildDetailRow(Icons.payment, "Consultation Fee", "₦8,500"),

            Spacer(),

            // CHAT NOW BUTTON (Replaces Reschedule)
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: ElevatedButton.icon(
                icon: Icon(Icons.chat_bubble, color: Colors.white),
                label: Text("Chat with Doctor Now", style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF339CFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: chat_screen(doctorData: doctorChatData),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF339CFF), size: 22.sp),
          SizedBox(width: 4.w),
          Text("$label:  ", style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600)),
          Text(value, style: GoogleFonts.inter(fontSize: 15.sp)),
        ],
      ),
    );
  }
}