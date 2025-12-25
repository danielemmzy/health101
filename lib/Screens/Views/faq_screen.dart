// screens/faqs_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});
  @override State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  final List<Map<String, dynamic>> faqs = [
    {"question": "How long does delivery take?", "answer": "Standard delivery takes 1–3 business days. Express delivery (same-day) is available in select cities for orders placed before 2 PM.", "isOpen": false},
    {"question": "Can I return medicines?", "answer": "Yes! Unopened and unused medicines can be returned within 7 days with original packaging and receipt.", "isOpen": false},
    {"question": "Are prescriptions required?", "answer": "Prescription medicines require a valid doctor’s prescription. Over-the-counter (OTC) items do not.", "isOpen": false},
    {"question": "How do I track my order?", "answer": "Once your order is confirmed, you’ll receive a tracking link via SMS and in the app under Order History → Track Order.", "isOpen": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Image.asset("assets/images/back2.png", width: 28, height: 28), onPressed: () => Navigator.pop(context)),
        title: Text("FAQs", style: GoogleFonts.inter(fontSize: 19.sp, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(6.w),
        itemCount: faqs.length,
        itemBuilder: (context, i) {
          return _buildFAQItem(faqs[i], i);
        },
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8F0F8), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(faq["question"], style: GoogleFonts.inter(fontSize: 15.5.sp, fontWeight: FontWeight.w600)),
        childrenPadding: EdgeInsets.all(5.w),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        onExpansionChanged: (expanded) => setState(() => faq["isOpen"] = expanded),
        trailing: Icon(faq["isOpen"] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF339CFF)),
        children: [
          Text(faq["answer"], style: GoogleFonts.inter(fontSize: 14.5.sp, height: 1.6, color: Colors.grey[700])),
        ],
      ),
    );
  }
}