import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../Views/Homepage.dart';

class chat_screen extends StatefulWidget {
  final int consultationId;
  final Map<String, dynamic> doctorData;

  const chat_screen({
    super.key,
    required this.consultationId,
    required this.doctorData,
  });

  @override
  State<chat_screen> createState() => _chat_screenState();
}

class _chat_screenState extends State<chat_screen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("assets/images/back1.png", width: 24, height: 24),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(type: PageTransitionType.fade, child: const Homepage()),
                (route) => false,
              );
            }
          },
        ),
        title: Text(
          widget.doctorData["name"] ?? "Doctor",
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
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
                        SizedBox(height: 16),
                        Text("No messages yet", style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final msg = _messages[i];
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
      decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(12)),
      child: Image.asset(asset, width: 20, height: 20, color: const Color(0xFF339CFF)),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(radius: 16, backgroundImage: AssetImage(widget.doctorData["image"] ?? "assets/images/male-doctor.png")),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF339CFF) : const Color(0xFFF0F0F0),
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
                  Text(text, style: GoogleFonts.inter(fontSize: 14.5.sp, color: isUser ? Colors.white : const Color(0xFF333333))),
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, -4))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF5F7FA), shape: BoxShape.circle),
            child: Image.asset("assets/images/pin.png", width: 20, height: 20, color: const Color(0xFF339CFF)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type message ...",
                hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 15.sp),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: const Color(0xFF339CFF), width: 1.5)),
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_controller.text.trim().isNotEmpty) {
                setState(() {
                  _messages.insert(0, {
                    "text": _controller.text.trim(),
                    "isUser": true,
                    "time": DateTime.now().toString().substring(11, 16),
                  });
                });
                _controller.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFF339CFF), shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}