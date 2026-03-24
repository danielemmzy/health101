// screens/health_details_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HealthDetailsScreen extends StatefulWidget {
  const HealthDetailsScreen({super.key});
  @override State<HealthDetailsScreen> createState() => _HealthDetailsScreenState();
}

class _HealthDetailsScreenState extends State<HealthDetailsScreen> {
  final Map<String, TextEditingController> controllers = {
    "weight": TextEditingController(text: "68"),
    "height": TextEditingController(text: "172"),
    "bloodPressure": TextEditingController(text: "120/80"),
    "heartRate": TextEditingController(text: "72"),
    "bloodSugar": TextEditingController(text: "95"),
    "calories": TextEditingController(text: "2200"),
  };

  @override
  void dispose() {
    controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Image.asset("assets/images/back2.png", width: 28, height: 28), onPressed: () => Navigator.pop(context)),
        title: Text("Health Details", style: GoogleFonts.inter(fontSize: 19.sp, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            _buildHealthCard("Weight (kg)", controllers["weight"]!, "assets/images/weight.png"),
            _buildHealthCard("Height (cm)", controllers["height"]!, "assets/images/weight.png"),
            _buildHealthCard("Blood Pressure", controllers["bloodPressure"]!, "assets/images/weight.png"),
            _buildHealthCard("Heart Rate (bpm)", controllers["heartRate"]!, "assets/images/heart.png"),
            _buildHealthCard("Blood Sugar (mg/dL)", controllers["bloodSugar"]!, "assets/images/weight.png"),
            _buildHealthCard("Daily Calories", controllers["calories"]!, "assets/images/weight.png"),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Health details updated! (Frontend only)"))),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF339CFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: Text("Save Changes", style: GoogleFonts.inter(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(String label, TextEditingController controller, String? iconPath) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8F0F8)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          if (iconPath != null) Image.asset(iconPath, width: 48, height: 48),
          if (iconPath != null) SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[700])),
                SizedBox(height: 1.h),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF339CFF)),
                  decoration: InputDecoration(border: InputBorder.none, hintText: "Enter value"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}