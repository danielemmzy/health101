import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:health101/features/auth/providers/consultation_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Views/doctor_search.dart';
import '../Views/chat_screen.dart';
import '../Widgets/appointmenCard.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final List<String> _tabs = ["Upcoming", "Completed", "Canceled"];
  String _selectedTab = "Upcoming";

  @override
  Widget build(BuildContext context) {
    final myConsultationsAsync = ref.watch(myConsultationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF333333), size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Consultations",
          style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF333333)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                PageTransition(type: PageTransitionType.rightToLeft, child: const CartScreen()),
              ),
              child: const Icon(Icons.shopping_cart_outlined, size: 28, color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myConsultationsProvider); // Force refresh from backend
        },
        child: Column(
          children: [
            // New Consultation Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.bottomToTop, child: const DoctorSearch()),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFE8F0F8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF339CFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 22),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        "Consult New Doctor",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E2E2E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Tabs
            SizedBox(
              height: 7.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                itemCount: _tabs.length,
                itemBuilder: (context, i) {
                  final tab = _tabs[i];
                  final isSelected = _selectedTab == tab;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = tab),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: 3.w),
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF339CFF) : const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        tab,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : const Color(0xFF2E2E2E),
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 3.h),

            // Appointments List
            Expanded(
              child: myConsultationsAsync.when(
                data: (consultations) {
                  print("📊 Consultations received: ${consultations.length}"); // Debug

                  if (consultations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 70, color: Colors.grey[400]),
                          SizedBox(height: 2.h),
                          Text(
                            "No $_selectedTab Consultations",
                            style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          ),
                          const Text("Your appointments will appear here"),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    itemCount: consultations.length,
                    itemBuilder: (context, index) {
                      final cons = consultations[index];
                      final doctor = cons['doctor'] ?? cons['Doctor'] ?? {}; // Handle possible key variations

                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.5.h),
                        child: AppointmentCard(
                          image: doctor['image_url'] ?? doctor['image'] ?? "assets/images/male-doctor.png",
                          name: doctor['name'] ?? doctor['full_name'] ?? "Dr. Unknown",   // ← Most important fix
                          specialty: doctor['specialty'] ?? "",
                          status: cons['status']?.toString().toLowerCase() ?? "upcoming",
                          doctorId: doctor['id'] ?? 0,
                          onChatPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: chat_screen(doctorData: doctor),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) {
                  print("❌ Error: $error");
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 10),
                        Text("Error: $error", textAlign: TextAlign.center),
                        TextButton(
                          onPressed: () => ref.invalidate(myConsultationsProvider),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
