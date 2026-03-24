// widgets/appointment_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:responsive_sizer/responsive_sizer.dart';


// widgets/appointmenCard.dart (FINAL VERSION)
class AppointmentCard extends StatelessWidget {
  final String image, name, specialty, status;
  final int doctorId;
  final VoidCallback? onChatPressed; // ← NEW

  const AppointmentCard({
    super.key,
    required this.image,
    required this.name,
    required this.specialty,
    
    required this.status,
    required this.doctorId,
    this.onChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(image, width: 70, height: 70, fit: BoxFit.cover)),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                Text(specialty, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14.sp)),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 2.w),
                    
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: status == "upcoming" ? Color(0xFF339CFF).withOpacity(0.15) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status[0].toUpperCase() + status.substring(1),
                  style: GoogleFonts.inter(color: status == "upcoming" ? Color(0xFF339CFF) : Colors.grey[700], fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 2.h),
              // CHAT NOW BUTTON (ALL TABS)
              TextButton.icon(
                onPressed: onChatPressed,
                icon: Icon(Icons.chat_bubble_outline, size: 16.sp, color: Color(0xFF339CFF)),
                label: Text("Chat Now", style: TextStyle(color: Color(0xFF339CFF), fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}