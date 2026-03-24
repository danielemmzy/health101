// screens/on_boarding.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Login-Signup/login_signup.dart';
import 'on_board1.dart';
import 'on_board2.dart';
import 'on_board3.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ONBOARDING PAGES
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              OnBoard1(),
              OnBoard2(),
              OnBoard3(),
            ],
          ),

          // BOTTOM CONTROLS — MOVED LOWER, NO OVERLAP
          Positioned(
            bottom: 8.h, // Lowered from screen edge
            left: 0,
            right: 0,
            child: Column(
              children: [
                // INDICATOR
                Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 12,
                      spacing: 6,
                      expansionFactor: 4,
                      activeDotColor: const Color(0xFF339CFF),
                      dotColor: const Color(0xFF339CFF).withOpacity(0.3),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // BUTTON ROW
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SKIP
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: const login_signup(),
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // NEXT / DONE BUTTON
                      GestureDetector(
                        onTap: () {
                          if (onLastPage) {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const login_signup(),
                              ),
                            );
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF339CFF),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF339CFF).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                onLastPage ? "Get Started" : "Next",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                onLastPage ? Icons.check : Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}