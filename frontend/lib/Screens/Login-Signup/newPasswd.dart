// screens/new_password_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../Views/Homepage.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 80),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create New Password",
                style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),

              Text(
                "Your new password must be different from previous ones",
                style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),

              // New Password
              _buildPasswordField("New Password", _passwordController, _obscure, () => setState(() => _obscure = !_obscure)),
              SizedBox(height: 3.h),

              // Confirm Password
              _buildPasswordField("Confirm Password", _confirmController, _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
              SizedBox(height: 6.h),

              // Confirm Button
              SizedBox(
                width: 88.w,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(type: PageTransitionType.fade, child: Homepage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF339CFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text("Confirm", style: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller, bool obscure, VoidCallback toggle) {
    return Container(
      width: 88.w,
      height: 7.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(onTap: toggle, child: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey)),
        ],
      ),
    );
  }
}