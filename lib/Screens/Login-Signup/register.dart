import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Login-Signup/verification_code.dart';
import 'login.dart';
import '../Widgets/auth_social_login.dart';
import '../Widgets/Auth_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: SizedBox(
            height: 6.h,
            width: 6.w,
            child: Image.asset("assets/images/back2.png"),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: const login()),
            );
          },
        ),
        title: Text(
          "Sign up",
          style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700),
        ),
        toolbarHeight: 11.h,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        child: Column(
          children: [
            SizedBox(height: 4.h),
            const Auth_text_field(
                text: "Enter your name", icon: "assets/images/email.png"),
            SizedBox(height: 1.h),
            const Auth_text_field(
                text: "Enter your Phone number",
                icon: "assets/images/phone-call.png"),
            SizedBox(height: 1.h),
            const Auth_text_field(
                text: "Enter your email", icon: "assets/images/person.png"),
            SizedBox(height: 1.h),
            const Auth_text_field(
                text: "Enter your password", icon: "assets/images/lock.png"),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? value) {},
                ),
                Expanded(
                  child: Text(
                    "I agree to the terms and conditions",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 6.h,
              width: 90.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const VerificationRegisterScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF339CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Create account",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style:
                      GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black87),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: const login()));
                  },
                  child: Text(
                    "Sign in",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF339CFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[400])),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    "or",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[400])),
              ],
            ),
            SizedBox(height: 3.h),
            const auth_social_logins(
                logo: "assets/images/google.png", text: "Sign up with Google"),
            SizedBox(height: 2.h),
            const auth_social_logins(
                logo: "assets/images/apple.png", text: "Sign up Apple"),
            SizedBox(height: 2.h),
            const auth_social_logins(
                logo: "assets/images/facebook.png", text: "Sign up facebook")
          ],
        ),
      ),
    );
  }
}

