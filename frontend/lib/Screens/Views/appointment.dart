// screens/appointment.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/appointmentBooked.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Widgets/doctorList.dart';
import 'doctor_details_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppointmentScreen extends StatelessWidget {
  final Map<String, String> doctor; // RECEIVE DOCTOR DATA
  const AppointmentScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Go back to DoctorDetails
          },
          child: Container(
            padding: EdgeInsets.all(12),
            child: Image.asset("assets/images/back1.png", width: 24, height: 24),
          ),
        ),
        title: Text(
          "Appointment",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset("assets/images/more.png", width: 24, height: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),

            // DYNAMIC DOCTOR CARD
            doctorList(
              distance: doctor["distance"]!,
              image: doctor["image"]!,
              maintext: doctor["name"]!,
              numRating: doctor["rating"]!,
              subtext: doctor["specialty"]!,
            ),

            SizedBox(height: 10),

            // DATE
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
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: AssetImage("assets/images/callender.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Wednesday, Jun 23, 2021 | 10:00 AM",
                      style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // REASON
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Reason", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  Text("Change", style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
                ],
              ),
            ),
            Divider(color: Colors.black12, indent: 20, endIndent: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: AssetImage("assets/images/pencil.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("Chest pain", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(color: Colors.black12, indent: 20, endIndent: 20),
            SizedBox(height: 20),

            // PAYMENT DETAILS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Payment Details", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 20),

            _buildPaymentRow("Consultation", "\$60"),
            _buildPaymentRow("Admin Fee", "\$01.00"),
            _buildPaymentRow("Additional Discount", "-"),
            SizedBox(height: 15),
            _buildPaymentRow("Total", "\$61.00", isTotal: true),
            SizedBox(height: 15),
            Divider(color: Colors.black12, indent: 20, endIndent: 20),
            SizedBox(height: 10),

            // PAYMENT METHOD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Payment Method", style: GoogleFonts.poppins(fontSize: 16.sp)),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Visa", style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 38, 39, 117))),
                  Text("Change", style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),

      // BOTTOM BOOK BUTTON
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
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
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

  // REUSABLE PAYMENT ROW
  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              color: isTotal ? Colors.black87 : Colors.black54,
              fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              color: isTotal ? Color(0xFF339CFF) : null,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}