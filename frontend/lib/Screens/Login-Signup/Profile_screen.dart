// screens/profile_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:health101/Screens/Views/faq_screen.dart';
import 'package:health101/Screens/Views/favourite_screen.dart';
import 'package:health101/Screens/Views/health_details_screen.dart';
import 'package:health101/Screens/Views/order_history_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  final TextEditingController _nameController = TextEditingController(text: "Amelia Renata");
  final TextEditingController _emailController = TextEditingController(text: "amelia@example.com");
  final TextEditingController _mobileController = TextEditingController(text: "+1 234 567 890");
  final TextEditingController _addressController = TextEditingController(text: "123 Main St, New York");
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF339CFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset("assets/images/shopping_cart.png", width: 24, height: 24),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(type: PageTransitionType.rightToLeft, child: const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ────── TOP HEADER (BLUE BG + AVATAR) ──────
            Container(
              width: 100.w,
              decoration: const BoxDecoration(
                color: Color(0xFF339CFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 2.h),

                  // Avatar with Edit
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 14.w,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 13.w,
                          backgroundImage: _image != null
                              ? FileImage(File(_image!.path)) as ImageProvider
                              : const AssetImage("assets/images/avatar.png"),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 6.w,
                              color: Color(0xFF339CFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Name
                  Text(
                    _nameController.text,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // Edit Profile Button
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit, color: Colors.white, size: 14.sp),
                    label: Text(
                      "Edit Profile",
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // ────── STATS CARDS ──────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                children: [
                  _buildStatCard(icon: Icons.monitor_weight, title: "Weight", value: "103 lbs"),
                  SizedBox(width: 3.w),
                  _buildStatCard(icon: Icons.local_fire_department, title: "Calories", value: "756 cal"),
                  SizedBox(width: 3.w),
                  _buildStatCard(icon: Icons.favorite, title: "Heart Rate", value: "215 bpm"),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // ────── EDITABLE FORM ──────
            Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField("Name", _nameController),
                  _buildTextField("Email", _emailController, keyboardType: TextInputType.emailAddress),
                  _buildTextField("Mobile No", _mobileController, keyboardType: TextInputType.phone),
                  _buildTextField("Address", _addressController),
                  _buildTextField("Password", _passwordController, obscureText: true),
                  _buildTextField("Confirm Password", _confirmPasswordController, obscureText: true),

                  SizedBox(height: 20),

                  // SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF339CFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Profile saved successfully!")),
                        );
                      },
                      child: Text(
                        "Save Changes",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5.h),
// ────── MENU LIST WITH FULL NAVIGATION ──────
Container(
  margin: EdgeInsets.symmetric(horizontal: 6.w),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
    ],
  ),
  child: Column(
    children: [
      _buildMenuItem("Favourites", Icons.bookmark, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => FavouritesScreen()));
      }),
      const Divider(height: 1, indent: 20, endIndent: 20),

      _buildMenuItem("Order History", Icons.receipt_long, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderHistoryScreen()),
        );
      }),
      const Divider(height: 1, indent: 20, endIndent: 20),

      _buildMenuItem("FAQs", Icons.question_answer_outlined, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => FAQsScreen()));
      }),
      Divider(height: 1, indent: 20, endIndent: 20),

      _buildMenuItem("Health Details", Icons.details_outlined, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HealthDetailsScreen()));
      }),
      Divider(height: 1, indent: 20, endIndent: 20),

      _buildMenuItem("Delete Account", Icons.delete_forever, () {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Delete Account?", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            content: Text("This action cannot be undone."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
              TextButton(
                onPressed: () {
                  // TODO: Delete account logic
                  Navigator.pop(ctx);
                },
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      }, color: Colors.red),
    ],
  ),
),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Color(0xFF339CFF)),
            SizedBox(height: 1.h),
            Text(title, style: GoogleFonts.poppins(fontSize: 12.sp, color: Color(0xFF2E2E2E), fontWeight: FontWeight.w500)),
            SizedBox(height: 0.5.h),
            Text(value, style: GoogleFonts.poppins(fontSize: 14.sp, color: Color(0xFF339CFF), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Color(0xFF339CFF), size: 22),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15.sp, color: color ?? Color(0xFF333333), fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}