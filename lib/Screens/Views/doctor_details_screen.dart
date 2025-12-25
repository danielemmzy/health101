// screens/doctor_details_screen.dart → FIXED, SAME DESIGN, ONLY BUTTONS CHANGED
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/chat_screen.dart';
import 'package:health101/Screens/Widgets/doctorList.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetails extends StatefulWidget {
  final Map<String, String> doctor;
  const DoctorDetails({super.key, required this.doctor});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool showExtendedText = false;

  Map<String, dynamic> get doctorChatData => {
        "id": 999,
        "image": widget.doctor["image"]!,
        "name": widget.doctor["name"]!,
        "specialty": widget.doctor["specialty"]!,
        "lastMessage": "Hello, how can I help you today?",
        "time": "Now",
        "unreadCount": 0,
        "messages": [
          {"text": "Hi! I'm Dr. ${widget.doctor["name"]}. How are you feeling?", "isUser": false, "time": "Just now"},
        ],
      };

  void _makeCall() async {
    final Uri url = Uri(scheme: 'tel', path: '+2348012345678');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Image.asset("assets/images/back1.png", width: 24, height: 24),
          ),
        ),
        title: Text("Doctor Details", style: GoogleFonts.poppins(fontSize: 18.sp)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                doctorList(
                  image: widget.doctor["image"]!,
                  maintext: widget.doctor["name"]!,
                  subtext: widget.doctor["specialty"]!,
                  numRating: widget.doctor["rating"]!,
                  distance: widget.doctor["distance"]!,
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("About", style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Text(
                        showExtendedText
                            ? "Dr. ${widget.doctor["name"]} is a highly experienced ${widget.doctor["specialty"]} with over 15 years in practice. Specializes in advanced treatment and patient care."
                            : "Dr. ${widget.doctor["name"]} is a highly experienced ${widget.doctor["specialty"]} with over 15 years...",
                        style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => showExtendedText = !showExtendedText),
                        child: Text(showExtendedText ? "Read less" : "Read more", style: TextStyle(color: Color(0xFF339CFF))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Your date/time picker here if any
              ],
            ),
          ),

          // EXACT SAME BOTTOM BAR DESIGN — ONLY BUTTONS CHANGED
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            color: Colors.white,
            child: Row(
              children: [
                // CALL ICON (was Chat)
                GestureDetector(
                  onTap: _makeCall,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Icon(Icons.phone, color: Color(0xFF339CFF), size: 28),
                  ),
                ),

                SizedBox(width: 20),

                // CHAT NOW BUTTON (was Book Appointment)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: chat_screen(doctorData: doctorChatData),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF339CFF),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Chat Now",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
}