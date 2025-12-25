// screens/schedule_screen.dart → FINAL BEAUTIFUL VERSION
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/doctor_search.dart';
import 'package:health101/Screens/Views/chat_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../Views/Homepage.dart';
import '../Views/cart_screen.dart';
import '../Widgets/appointmenCard.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<String> _tabs = ["Upcoming", "Completed", "Canceled"];
  String _selectedTab = "Upcoming";

  // DUMMY DATA
  final List<Map<String, dynamic>> upcomingAppointments = [
    {"doctor": {"id": 1, "image": "assets/images/male-doctor.png", "name": "Dr. Marcus Horizon", "specialty": "Cardiologist"}, "status": "upcoming"},
    {"doctor": {"id": 2, "image": "assets/images/docto3.png", "name": "Dr. Maria Elena", "specialty": "Psychologist"}, "status": "upcoming"},
    {"doctor": {"id": 3, "image": "assets/images/doctor2.png", "name": "Dr. Stevi Jessi", "specialty": "Orthopedist"}, "date": "Mon, Jun 28", "time": "11:00 AM", "status": "upcoming"},
  ];

  final List<Map<String, dynamic>> completedAppointments = [
    {"doctor": {"id": 4, "image": "assets/images/black-doctor.png", "name": "Dr. James Carter", "specialty": "Neurologist"}, "status": "completed"},
    {"doctor": {"id": 5, "image": "assets/images/male-doctor.png", "name": "Dr. Sarah Kim", "specialty": "Pediatrician"},  "status": "completed"},
  ];

  final List<Map<String, dynamic>> canceledAppointments = [
    {"doctor": {"id": 6, "image": "assets/images/doctor2.png", "name": "Dr. Lisa Wong", "specialty": "Gynecologist"},  "status": "canceled"},
  ];

  List<Map<String, dynamic>> get currentAppointments {
    switch (_selectedTab) {
      case "Upcoming": return upcomingAppointments;
      case "Completed": return completedAppointments;
      case "Canceled": return canceledAppointments;
      default: return upcomingAppointments;
    }
  }

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
          onPressed: () =>  Navigator.pop(context),
        ),
        title: Text("Consultations", style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CartScreen())),
              child: Stack(
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
                  Positioned(
                    right: 0, top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text("7", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // PLUS BUTTON
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            child: GestureDetector(
              onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: DoctorSearch())),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFFE8F0F8)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Color(0xFF339CFF), shape: BoxShape.circle),
                      child: Icon(Icons.add, color: Colors.white, size: 22),
                    ),
                    SizedBox(width: 3.w),
                    Text("Consult New Doctor", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Color(0xFF2E2E2E))),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // BEAUTIFUL HORIZONTAL TAB BAR (Your Design!)
          SizedBox(
            height: 7.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              itemCount: _tabs.length,
              itemBuilder: (context, i) {
                final tab = _tabs[i];
                final isSelected = _selectedTab == tab;

                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = tab),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF339CFF) : Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: isSelected ? Color(0xFF339CFF) : Color(0xFFE8F0F8), width: 1.5),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Color(0xFF339CFF).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 6))]
                          : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: Offset(0, 3))],
                    ),
                    child: Text(
                      tab,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : Color(0xFF2E2E2E),
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          // APPOINTMENT LIST
          Expanded(
            child: currentAppointments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 70, color: Colors.grey[400]),
                        SizedBox(height: 2.h),
                        Text("No $_selectedTab Consultations", style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                        Text("Your Consultations will appear here", style: GoogleFonts.inter(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    itemCount: currentAppointments.length,
                    itemBuilder: (context, index) {
                      final appt = currentAppointments[index];
                      final doctor = appt["doctor"] as Map<String, dynamic>;

                      final doctorChatData = {
                        "id": doctor["id"],
                        "image": doctor["image"],
                        "name": doctor["name"],
                        "specialty": doctor["specialty"],
                        "lastMessage": "Consultations on ${appt["date"]} at ${appt["time"]}",
                        "time": "Now",
                        "unreadCount": 0,
                        "messages": [
                          {"text": "Your Consultation is scheduled for ${appt["date"]} at ${appt["time"]}.", "isUser": false, "time": "Just now"},
                        ],
                      };

                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.5.h),
                        child: AppointmentCard(
                          image: doctor["image"]!,
                          name: doctor["name"]!,
                          specialty: doctor["specialty"]!,
                          status: appt["status"],
                          doctorId: doctor["id"],
                          onChatPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(type: PageTransitionType.bottomToTop, child: chat_screen(doctorData: doctorChatData)),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
