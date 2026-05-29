import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:health101/Screens/Views/chat_screen.dart';
import 'package:health101/features/auth/providers/consultation_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class message_tab_all extends ConsumerWidget {
  const message_tab_all({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myConsultationsAsync = ref.watch(myConsultationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF333333), size: 26),
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
          "Inbox",
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
        onRefresh: () async => ref.invalidate(myConsultationsProvider),
        child: myConsultationsAsync.when(
          data: (consultations) {
            if (consultations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 20),
                    Text("No messages yet", style: GoogleFonts.inter(fontSize: 18.sp, color: Colors.grey)),
                    const Text("Your conversations will appear here"),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              itemCount: consultations.length,
              itemBuilder: (context, index) {
                final cons = consultations[index];
                final doctor = cons['doctor'] ?? {};

                return _buildMessageItem(
                  consultationId: cons['id'],
                  image: doctor['image_url'] ?? doctor['image'] ?? "assets/images/male-doctor.png",
                  name: doctor['name'] ?? doctor['full_name'] ?? "Dr. Unknown",
                  lastMessage: cons['notes'] ?? "Consultation started",
                  time: cons['created_at']?.toString().substring(0, 10) ?? "Just now",
                  unreadCount: 0, // You can implement unread count later
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: chat_screen(
                          consultationId: cons['id'],
                          doctorData: doctor,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text("Error loading messages: $error")),
        ),
      ),
    );
  }

  Widget _buildMessageItem({
    required int consultationId,
    required String image,
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10.w,
                backgroundImage: AssetImage(image),
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      lastMessage,
                      style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(time, style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.grey[500])),
                  if (unreadCount > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF339CFF),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadCount.toString(),
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}