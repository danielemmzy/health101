import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/appointmentBooked.dart';
import 'package:health101/Screens/Widgets/doctorList.dart';
import 'package:health101/features/auth/providers/doctor_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';


class AppointmentScreen extends ConsumerWidget {
  final int doctorId;

  const AppointmentScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorAsync = ref.watch(doctorDetailProvider(doctorId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Image.asset("assets/images/back1.png", width: 24, height: 24),
          ),
        ),
        title: Text("Appointment", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp)),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
      ),
      body: doctorAsync.when(
        data: (doctor) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5),

                // Dynamic Doctor Card
                doctorList(
                  distance: "1.2km Away", // You can add real distance later
                  image: doctor["image"] ?? "assets/images/male-doctor.png",
                  maintext: doctor["name"] ?? "Dr. Unknown",
                  numRating: doctor["rating"]?.toString() ?? "4.5",
                  subtext: doctor["specialty"] ?? "Specialist",
                ),

                SizedBox(height: 20),

                // Date & Reason (Static for now, can be made dynamic later)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                      Text("Change", style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
                    ],
                  ),
                ),
                // ... rest of your date/reason/payment UI remains the same ...

                SizedBox(height: 100),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Failed to load doctor info")),
      ),

      // Bottom Book Button
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Total", style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.grey)),
                Text("\$61", style: GoogleFonts.inter(fontSize: 19.sp, fontWeight: FontWeight.w600)),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AppointmentBookedMessageScreen(),
                );
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.43,
                decoration: BoxDecoration(
                  color: Color(0xFF339CFF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Book",
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}