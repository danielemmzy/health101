import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/features/auth/providers/chat_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:health101/core/utilis/token_storage.dart';

class chat_screen extends ConsumerStatefulWidget {
  final int consultationId;
  final Map<String, dynamic> doctorData;

  const chat_screen({
    super.key,
    required this.consultationId,
    required this.doctorData,
  });

  @override
  ConsumerState<chat_screen> createState() => _chat_screenState();
}

class _chat_screenState extends ConsumerState<chat_screen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? _channel;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  void _initializeChat() {
    if (_initialized) return;
    _initialized = true;

    // Safe Riverpod usage AFTER build
    ref.invalidate(chatHistoryProvider(widget.consultationId));

    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    _channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://127.0.0.1:8000/consultations/chat/${widget.consultationId}?token=$token',
      ),
    );

    _channel!.stream.listen(
      (message) {
        ref.invalidate(chatHistoryProvider(widget.consultationId));
        _scrollToBottom();
      },
      onError: (error) => print("WebSocket Error: $error"),
      onDone: () => print("WebSocket closed"),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    _channel?.sink.add(text);

    ref.invalidate(chatHistoryProvider(widget.consultationId));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatHistoryAsync =
        ref.watch(chatHistoryProvider(widget.consultationId));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                widget.doctorData['image_url'] ??
                    "assets/images/male-doctor.png",
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctorData['name'] ?? "Doctor",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.doctorData['specialty'] ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatHistoryAsync.when(
              data: (messages) => ListView.builder(
                controller: _scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser =
                      msg['sender_name'] == "You" ||
                      msg['sender_id'] == 14;

                  return _buildMessageBubble(msg, isUser);
                },
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text("Failed to load messages")),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isUser) {
    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding:
            EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        decoration: BoxDecoration(
          color:
              isUser ? const Color(0xFF339CFF) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft:
                isUser ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight:
                isUser ? const Radius.circular(4) : const Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg['content'],
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                color:
                    isUser ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 0.4.h),
            Text(
              msg['created_at']
                      ?.toString()
                      .substring(11, 16) ??
                  "",
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: isUser
                    ? Colors.white70
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle:
                    GoogleFonts.inter(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF339CFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}