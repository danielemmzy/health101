// screens/verification_register.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Login-Signup/newPasswd.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';



class VerificationForgotScreen extends StatefulWidget {
  const VerificationForgotScreen({super.key});

  @override
  State<VerificationForgotScreen> createState() => _VerificationForgotScreenState();
}

class _VerificationForgotScreenState extends State<VerificationForgotScreen> {
  late Timer _timer;
  int _secondsRemaining = 4 * 60;
  bool _canResend = false;
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();
    _focusNodes[0].requestFocus();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    setState(() {
      _secondsRemaining = 4 * 60;
      _canResend = false;
      for (var c in _controllers) c.clear();
      _focusNodes[0].requestFocus();
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _minutes => (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
  String get _seconds => (_secondsRemaining % 60).toString().padLeft(2, '0');

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
              // Title
              Text(
                "Did you receive the code?",
                style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),

              // Subtitle
              Text(
                "Enter the 4-digit code sent to your phone or email",
                style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),

              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (i) => _buildOtpBox(i)),
              ),
              SizedBox(height: 5.h),

              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimerBox(_minutes, 'Minutes'),
                  SizedBox(width: 4.w),
                  _buildTimerBox(_seconds, 'Seconds'),
                ],
              ),
              SizedBox(height: 6.h),

              // Verify Button
              SizedBox(
                width: 88.w,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(type: PageTransitionType.rightToLeft, child: NewPasswordScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF339CFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text("Verify", style: GoogleFonts.poppins(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
              SizedBox(height: 3.h),

              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive code? ", style: GoogleFonts.poppins(fontSize: 14.sp)),
                  GestureDetector(
                    onTap: _canResend ? _resendCode : null,
                    child: Text(
                      "Resend",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: _canResend ? Color(0xFF339CFF) : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 16.w,
      height: 16.w,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFE0E0E0)),
        ),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.length == 1 && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTimerBox(String value, String label) {
    return Column(
      children: [
        Container(
          width: 38.w,
          height: 14.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFE5EDF4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(value, style: GoogleFonts.lexend(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Color(0xFF0C141C))),
        ),
        SizedBox(height: 1.h),
        Text(label, style: GoogleFonts.lexend(fontSize: 13.sp, color: Color(0xFF0C141C))),
      ],
    );
  }
}