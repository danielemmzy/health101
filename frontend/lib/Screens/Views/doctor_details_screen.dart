import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/features/auth/providers/doctor_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Views/chat_screen.dart';
import '../Widgets/doctorList.dart';

class DoctorDetails extends ConsumerWidget {
  final int doctorId;

  const DoctorDetails({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(doctorDetailProvider(doctorId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset("assets/images/back1.png", width: 24, height: 24),
          ),
        ),
        title: Text("Doctor Details", style: GoogleFonts.poppins(fontSize: 18.sp)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: doctorAsync.when(
        data: (doctor) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    doctorList(
                      image: doctor["image_url"] ?? doctor["image"] ?? "assets/images/male-doctor.png",
                      maintext: doctor["name"] ?? "Dr. Unknown",
                      subtext: doctor["specialty"] ?? "Specialist",
                      numRating: doctor["rating"]?.toString() ?? "4.5",
                      distance: "1.2km Away",
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("About Doctor", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(
                            doctor["bio"] ?? "No additional information available.",
                            style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black87, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
                ),
                child: Row(
                  children: [
                    // Call Button
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri(scheme: 'tel', path: '+2348012345678');
                        if (await canLaunchUrl(url)) await launchUrl(url);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.phone, color: Color(0xFF339CFF), size: 28),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Chat Button - Fixed
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: chat_screen(
                                consultationId: 0,           // 0 = new chat (no consultation yet)
                                doctorData: doctor,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF339CFF),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Start Chat",
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Failed to load doctor details")),
      ),
    );
  }
}