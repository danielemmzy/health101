// lib/Screens/Login-Signup/verification_register.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Login-Signup/enable_location.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:async';
import 'package:dio/dio.dart';

import '../../features/auth/providers/auth_provider.dart';

class VerificationRegisterScreen extends ConsumerStatefulWidget {
  final String email;

  const VerificationRegisterScreen({super.key, required this.email});

  @override
  ConsumerState<VerificationRegisterScreen> createState() => _VerificationRegisterScreenState();
}

class _VerificationRegisterScreenState extends ConsumerState<VerificationRegisterScreen> {
  late Timer _timer;
  int _secondsRemaining = 300; // 5 minutes
  bool _canResend = false;

  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String _enteredCode = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
    _focusNodes[0].requestFocus();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
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

  Future<void> _resendCode() async {
    if (!mounted) return;

    setState(() {
      _secondsRemaining = 300;
      _canResend = false;
      _enteredCode = "";
      for (var c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    });
    _startTimer();

    try {
      await Dio().post(
        'http://127.0.0.1:8000/auth/send-verification-code',
        data: {'email': widget.email},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification code resent")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to resend code")),
        );
      }
    }
  }

  Future<void> _verifyCode() async {
    _enteredCode = _controllers.map((c) => c.text).join();

    if (_enteredCode.length != 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter full 6-digit code")),
        );
      }
      return;
    }

    try {
      await Dio().post(
        'http://127.0.0.1:8000/auth/verify-code',
        data: {
          'email': widget.email,
          'code': _enteredCode,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Verification successful!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const EnableLocation(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid or expired code")),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
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
              Text(
                "Did you receive the code?",
                style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),
              Text(
                "Enter the 6-digit code sent to ${widget.email}",
                style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) => _buildOtpBox(i)),
              ),

              SizedBox(height: 5.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimerBox(_minutes, 'Minutes'),
                  SizedBox(width: 4.w),
                  _buildTimerBox(_seconds, 'Seconds'),
                ],
              ),

              SizedBox(height: 6.h),

              SizedBox(
                width: 88.w,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF339CFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    "Verify",
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
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
                  Text("Didn't receive code? ", style: GoogleFonts.poppins(fontSize: 14.sp)),
                  GestureDetector(
                    onTap: _canResend ? _resendCode : null,
                    child: Text(
                      "Resend",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: _canResend ? const Color(0xFF339CFF) : Colors.grey,
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
      width: 14.w,
      height: 14.w,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.length == 1 && index < 5) {
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
            color: const Color(0xFFE5EDF4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            value,
            style: GoogleFonts.lexend(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0C141C),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(label, style: GoogleFonts.lexend(fontSize: 13.sp, color: const Color(0xFF0C141C))),
      ],
    );
  }
}