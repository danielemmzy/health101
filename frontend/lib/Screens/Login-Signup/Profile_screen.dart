import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/Screens/Views/cart_screen.dart';
import 'package:health101/Screens/Views/faq_screen.dart';
import 'package:health101/Screens/Views/favourite_screen.dart';
import 'package:health101/Screens/Views/health_details_screen.dart';
import 'package:health101/Screens/Views/order_history_screen.dart';
import 'package:health101/features/auth/providers/profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profileAsync = await ref.read(profileProvider.future);
    if (profileAsync != null) {
      _nameController.text = profileAsync['full_name'] ?? '';
      _emailController.text = profileAsync['email'] ?? '';
      _mobileController.text = profileAsync['phone'] ?? '';
      _addressController.text = profileAsync['address'] ?? '';
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    final success = await ref.read(profileUpdateProvider.notifier).updateProfile(
          fullName: _nameController.text.trim(),
          phone: _mobileController.text.trim(),
          address: _addressController.text.trim(),
        );

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      setState(() => _isEditing = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile")),
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = pickedFile);
      // TODO: Upload image later
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF339CFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Profile", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset("assets/images/shopping_cart.png", width: 24, height: 24),
            onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const CartScreen())),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (user) => SingleChildScrollView(
          child: Column(
            children: [
              // Top Header
              Container(
                width: 100.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF339CFF),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 14.w,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 13.w,
                            backgroundImage: _image != null
                                ? FileImage(File(_image!.path))
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
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.camera_alt, size: 6.w, color: Color(0xFF339CFF)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(_nameController.text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 1.h),
                    TextButton.icon(
                      onPressed: () => setState(() => _isEditing = !_isEditing),
                      icon: Icon(Icons.edit, color: Colors.white, size: 14.sp),
                      label: Text(_isEditing ? "Cancel" : "Edit Profile", style: GoogleFonts.inter(color: Colors.white, fontSize: 13.sp)),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Stats
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  children: [
                    _buildStatCard(Icons.monitor_weight, "Weight", "103 lbs"),
                    SizedBox(width: 3.w),
                    _buildStatCard(Icons.local_fire_department, "Calories", "756 cal"),
                    SizedBox(width: 3.w),
                    _buildStatCard(Icons.favorite, "Heart Rate", "72 bpm"),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Form
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _buildTextField("Full Name", _nameController, enabled: _isEditing),
                    _buildTextField("Email", _emailController, enabled: false),
                    _buildTextField("Mobile No", _mobileController, enabled: _isEditing, keyboardType: TextInputType.phone),
                    _buildTextField("Address", _addressController, enabled: _isEditing),

                    SizedBox(height: 25),

                    if (_isEditing)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF339CFF),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: _isSaving ? null : _saveProfile,
                          child: _isSaving
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text("Save Changes", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 5.h),

              // Menu
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _buildMenuItem("Favourites", Icons.bookmark, () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavouritesScreen()))),
                    _buildMenuItem("Order History", Icons.receipt_long, () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryScreen()))),
                    _buildMenuItem("Health Details", Icons.details_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => HealthDetailsScreen()))),
                    _buildMenuItem("FAQs", Icons.question_answer_outlined, () => Navigator.push(context, MaterialPageRoute(builder: (_) => FAQsScreen()))),
                  ],
                ),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Failed to load profile")),
      ),
    );
  }

  // Helper Widgets
  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF333333))),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: const Color(0xFF339CFF)),
            SizedBox(height: 1.h),
            Text(title, style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF2E2E2E))),
             SizedBox(height: 0.5.h),
            Text(value, style: GoogleFonts.poppins(fontSize: 14.sp, color: const Color(0xFF339CFF), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF339CFF), size: 22),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15.sp, color: const Color(0xFF333333), fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}