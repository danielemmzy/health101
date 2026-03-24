// screens/forgot_pass.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import 'login.dart';
import '../Widgets/TabbarPages/tab1.dart';
import '../Widgets/TabbarPages/tab2.dart';


class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: Image.asset("assets/images/back2.png", width: 24, height: 24),
          onPressed: () => Navigator.pushReplacement(
            context,
            PageTransition(type: PageTransitionType.fade, child: const login()),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TITLE
              Text(
                "Forgot your password?",
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),

              // SUBTITLE
              Text(
                "Enter your email or phone number, we will send you a confirmation code",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),

              // TAB BAR
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Color(0xFF339CFF),
                  unselectedLabelColor: Colors.grey.shade600,
                  labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15.sp),
                  tabs: [
                    Tab(text: "Email"),
                    Tab(text: "Phone"),
                  ],
                ),
              ),
              SizedBox(height: 4.h),

              // TAB CONTENT
              SizedBox(
                height: 35.h, // Responsive height
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    tab1(),
                    tab2(),
                  ],
                ),
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}
