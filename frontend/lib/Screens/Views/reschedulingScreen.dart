// screens/reschedule_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Widgets/doctorList.dart';

class RescheduleScreen extends StatelessWidget {
  final Map<String, String> doctor;
  final String currentDate;  // e.g., "Wed, Jun 23"
  final String currentTime;  // e.g., "10:00 AM"

  const RescheduleScreen({
    super.key,
    required this.doctor,
    required this.currentDate,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "Reschedule Appointment",
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

            // DOCTOR CARD - SAME AS APPOINTMENT
            doctorList(
              distance: doctor["distance"] ?? "800m Away",
              image: doctor["image"]!,
              maintext: doctor["name"]!,
              numRating: doctor["rating"] ?? "4.7",
              subtext: doctor["specialty"]!,
            ),

            SizedBox(height: 15),

            // CURRENT APPOINTMENT WARNING
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFFF6B6B)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFFF6B6B), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Appointment", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        Text("$currentDate | $currentTime", style: GoogleFonts.inter(fontSize: 15.sp)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // EXACT SAME CONTENT AS APPOINTMENT SCREEN
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("New Date", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600)),
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
                    height: 50, width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(image: AssetImage("assets/images/callender.png"), fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Text("Select new date...", style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.black54))),
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
                    height: 50, width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(image: AssetImage("assets/images/pencil.png"), fit: BoxFit.contain),
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

            // PAYMENT DETAILS - SAME AS APPOINTMENT
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Payment Details", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 20),
            _buildRow("Consultation", "\$60"),
            _buildRow("Admin Fee", "\$01.00"),
            _buildRow("Additional Discount", "-"),
            SizedBox(height: 15),
            _buildRow("Total", "\$61.00", isTotal: true),
            SizedBox(height: 15),
            Divider(color: Colors.black12, indent: 20, endIndent: 20),
            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Payment Method", style: GoogleFonts.poppins(fontSize: 16.sp)),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Visa", style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 38, 39, 117))),
                  Text("Change", style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 100),
          ],
        ),
      ),

      // BOTTOM BUTTON - SAYS "Confirm Reschedule"
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Appointment rescheduled successfully!")),
                );
                Navigator.pop(context);
                Navigator.pop(context); // Go back to schedule
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Color(0xFF339CFF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Confirm Reschedule",
                    style: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 15.sp, color: isTotal ? Colors.black87 : Colors.black54)),
          Text(value, style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal, color: isTotal ? Color(0xFF339CFF) : null)),
        ],
      ),
    );
  }
}