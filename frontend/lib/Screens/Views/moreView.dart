// screens/more_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Login-Signup/Profile_screen.dart';
import 'package:health101/Screens/Login-Signup/login.dart';
import 'package:health101/Screens/Login-Signup/shedule_screen.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:health101/Screens/Views/aboutUs.dart';
import 'package:health101/Screens/Views/articlePage.dart';
import 'package:health101/Screens/Views/paymentDetails.dart';
import 'package:health101/Screens/Widgets/TabbarPages/message_tab_all.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

// Replace with your actual screens
import 'notification_screen.dart';
import 'cart_screen.dart';






class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  List<Map<String, dynamic>> moreArr = [
    {"index": "1", "name": "Profile Overview", "icon": Icons.person, "unread": 0},
    {"index": "2", "name": "Appointments", "icon": Icons.calendar_today, "unread": 3},
    {"index": "3", "name": "Payment Details", "icon": Icons.payment, "unread": 0},
    {"index": "4", "name": "My Orders", "icon": Icons.shopping_bag, "unread": 7},
    {"index": "5", "name": "Notifications", "icon": Icons.notifications, "unread": 12},
    {"index": "6", "name": "Inbox", "icon": Icons.mail, "unread": 5},
    {"index": "7", "name": "Help & Support", "icon": Icons.help, "unread": 0},
    {"index": "8", "name": "About Us", "icon": Icons.info, "unread": 0},
    {"index": "9", "name": "Logout", "icon": Icons.logout, "unread": 0},
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
      // Normal back (previous screen)
      Navigator.pop(context);
    } else {
      // No history → go to Homepage
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: Homepage(), // Your home screen
        ),
        (route) => false, // Remove all previous routes
      );
    }
  },
        ),
        title: Text(
          "More",
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

      // BODY: LIST OF OPTIONS
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: moreArr.length,
          itemBuilder: (context, index) {
            final item = moreArr[index];
            final unread = item["unread"] as int;

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _handleTap(context, item["index"].toString()),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // ICON
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          item["icon"] as IconData,
                          color: Color(0xFF339CFF),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),

                      // TITLE
                      Expanded(
                        child: Text(
                          item["name"],
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),

                      // UNREAD BADGE
                      if (unread > 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            unread.toString(),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      SizedBox(width: 12),

                      // ARROW
                      Icon(Icons.chevron_right, color: Color(0xFF999999), size: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, String index) {
    switch (index) {
      case "1":
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ProfileScreen()));
        break;
      case "2":
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ScheduleScreen()));
        break;
      case "3":
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentDetailsScreen()));
        break;
      case "4":
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CartScreen()));
        break;
      case "5":
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: NotificationScreen()));
        break;
      case "6":
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: message_tab_all()));
        break;
      case "7":
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: articlePage()));
        break;
      case "8":
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AboutUsScreen()));
        break;
      case "9":
       Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: login()));
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Logout", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        content: Text("Are you sure you want to logout?", style: GoogleFonts.inter()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: StadiumBorder()),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out successfully")));
            },
            child: Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}