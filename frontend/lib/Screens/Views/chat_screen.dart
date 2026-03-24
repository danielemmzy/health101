// screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../Views/Homepage.dart';

class chat_screen extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  const chat_screen({super.key, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    final messages = doctorData["messages"] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("assets/images/back1.png", width: 24, height: 24),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(context, PageTransition(type: PageTransitionType.fade, child: Homepage()), (route) => false);
            }
          },
        ),
        title: Text(
          doctorData["name"],
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17.sp),
        ),
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                _icon("assets/images/video_call.png"),
                SizedBox(width: 12),
                _icon("assets/images/call.png"),
                SizedBox(width: 12),
                _icon("assets/images/more.png"),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];
                return _buildMessageBubble(msg["text"], msg["isUser"], msg["time"]);
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _icon(String asset) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(12)),
      child: Image.asset(asset, width: 20, height: 20, color: Color(0xFF339CFF)),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(radius: 16, backgroundImage: AssetImage(doctorData["image"])),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? Color(0xFF339CFF) : Color(0xFFF0F0F0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 16 : 0),
                  topRight: Radius.circular(isUser ? 0 : 16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(text, style: GoogleFonts.inter(fontSize: 14.5.sp, color: isUser ? Colors.white : Color(0xFF333333))),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(time, style: GoogleFonts.inter(fontSize: 10.sp, color: isUser ? Colors.white70 : Colors.grey)),
                      if (isUser) ...[SizedBox(width: 4), Image.asset("assets/images/ticks.png", width: 14, height: 14)],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, -4))]),
      child: Row(
        children: [
          Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFF5F7FA), shape: BoxShape.circle), child: Image.asset("assets/images/pin.png", width: 20, height: 20, color: Color(0xFF339CFF))),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type message ...",
                hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 15.sp),
                filled: true,
                fillColor: Color(0xFFF7F7F7),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Color(0xFF339CFF), width: 1.5)),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF339CFF), shape: BoxShape.circle), child: Icon(Icons.send, color: Colors.white, size: 20)),
        ],
      ),
    );
  }
}