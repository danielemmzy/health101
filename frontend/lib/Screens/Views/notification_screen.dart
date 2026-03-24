// screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/notification_details_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';



class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "Prescription Ready",
      "message": "Your prescription for Ibuprofen is ready at Health101 Pharmacy.",
      "time": "2 min ago",
      "isRead": false,
      "icon": Icons.receipt,
      "color": const Color(0xFF339CFF),
    },
    {
      "id": 2,
      "title": "Order Delivered",
      "message": "Your Vitamin C order has been delivered successfully. Thank you for choosing us!",
      "time": "1 hour ago",
      "isRead": true,
      "icon": Icons.local_shipping,
      "color": Colors.green,
    },
    {
      "id": 3,
      "title": "New Offer!",
      "message": "Get 20% off on First Aid Essentials this weekend. Limited time only!",
      "time": "3 hours ago",
      "isRead": false,
      "icon": Icons.local_offer,
      "color": Colors.orange,
    },
    {
      "id": 4,
      "title": "Appointment Reminder",
      "message": "You have an appointment with Dr. Marcus tomorrow at 10:00 AM. Don't forget!",
      "time": "1 day ago",
      "isRead": true,
      "icon": Icons.calendar_today,
      "color": const Color(0xFF339CFF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("assets/images/back2.png", width: 28, height: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.inter(fontSize: 19.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2E2E2E)),
        ),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return _buildNotificationCard(context, notif);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 70, color: Colors.grey[400]),
          SizedBox(height: 2.h),
          Text("No notifications yet", style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey[600])),
          Text("We'll notify you when something new arrives", style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, Map<String, dynamic> notif) {
    return GestureDetector(
      onTap: () {
        // Mark as read
        notif["isRead"] = true;
        // Open detail screen
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => NotificationDetailScreen(notification: notif),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: notif["isRead"] ? Colors.white : const Color(0xFFF0F8FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: notif["isRead"] ? const Color(0xFFE8F0F8) : const Color(0xFF339CFF).withOpacity(0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: (notif["color"] as Color).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(notif["icon"], color: notif["color"], size: 24),
            ),
            SizedBox(width: 3.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif["title"],
                    style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    notif["message"],
                    style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[700], height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    notif["time"],
                    style: GoogleFonts.inter(fontSize: 11.5.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

            // Unread indicator
            if (!notif["isRead"])
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}