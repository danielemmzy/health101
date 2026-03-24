// screens/message_tab_all.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:health101/Screens/Views/chat_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';



class message_tab_all extends StatefulWidget {
  const message_tab_all({super.key});

  @override
  State<message_tab_all> createState() => _message_tab_allState();
}

class _message_tab_allState extends State<message_tab_all> {
  // DYNAMIC DOCTOR LIST WITH MESSAGES
  final List<Map<String, dynamic>> doctors = [
    {
      "id": 1,
      "image": "assets/images/male-doctor.png",
      "name": "Dr. Marcus Horizon",
      "specialty": "Cardiologist",
      "lastMessage": "I don't have any fever, but headache...",
      "time": "10:24",
      "unreadCount": 2,
      "messages": [
        {"text": "Hello. how can i help you?", "isUser": false, "time": "10:20 AM"},
        {"text": "I have suffering from headache and cold for 3 days, I took 2 tablets of dolo,\nbut still pain", "isUser": true, "time": "10:22 AM"},
        {"text": "Got it. Let me review your symptoms...", "isUser": false, "time": "10:24 AM"},
      ],
    },
    {
      "id": 2,
      "image": "assets/images/docto3.png",
      "name": "Dr. Alysa Hana",
      "specialty": "Pediatrician",
      "lastMessage": "Hello, How can i help you?",
      "time": "09:50",
      "unreadCount": 1,
      "messages": [
        {"text": "Hello. how can i help you?", "isUser": false, "time": "09:45 AM"},
        {"text": "My child has fever since yesterday", "isUser": true, "time": "09:48 AM"},
        {"text": "Please give 5ml of Crocin every 6 hours", "isUser": false, "time": "09:50 AM"},
      ],
    },
    {
      "id": 3,
      "image": "assets/images/doctor2.png",
      "name": "Dr. Maria Elena",
      "specialty": "Neurologist",
      "lastMessage": "Do you have fever?",
      "time": "Yesterday",
      "unreadCount": 3,
      "messages": [
        {"text": "Do you have fever?", "isUser": false, "time": "08:30 AM"},
        {"text": "No, but severe headache and nausea", "isUser": true, "time": "08:32 AM"},
        {"text": "Please get a CT scan done today", "isUser": false, "time": "08:35 AM"},
        {"text": "Okay, sending report", "isUser": true, "time": "08:40 AM"},
      ],
    },
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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(type: PageTransitionType.fade, child: Homepage()),
                (route) => false,
              );
            }
          },
        ),
        title: Text(
          "Inbox",
          style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Color(0xFF333333)),
        ),
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
                      child: Text("7", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: doctors.isEmpty
          ? Center(child: Text("No messages yet", style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doc = doctors[index];
                return _buildMessageItem(
                  image: doc["image"],
                  name: doc["name"],
                  message: doc["lastMessage"],
                  time: doc["time"],
                  count: doc["unreadCount"],
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: chat_screen(doctorData: doc),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildMessageItem({
    required String image,
    required String name,
    required String message,
    required String time,
    required int count,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: Offset(0, 2))],
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 10.w, backgroundImage: AssetImage(image), backgroundColor: Colors.grey[200]),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Color(0xFF0C141C)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: 0.5.h),
                    Text(message, style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(time, style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.grey[500])),
                  if (count > 0) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
                      decoration: BoxDecoration(color: Color(0xFF339CFF), shape: BoxShape.circle),
                      constraints: BoxConstraints(minWidth: 5.w, minHeight: 5.w),
                      child: Text(count.toString(), style: GoogleFonts.inter(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}