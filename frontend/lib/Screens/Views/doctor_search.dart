import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health101/features/auth/providers/consultation_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Widgets/doctorList.dart';
import 'doctor_details_screen.dart';

class DoctorSearch extends ConsumerStatefulWidget {
  const DoctorSearch({super.key});

  @override
  ConsumerState<DoctorSearch> createState() => _DoctorSearchState();
}

class _DoctorSearchState extends ConsumerState<DoctorSearch> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = "All";

  @override
  Widget build(BuildContext context) {
    final doctorsAsync = ref.watch(availableDoctorsProvider);

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
        title: Text("Find Doctors", style: GoogleFonts.poppins(fontSize: 18.sp, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(5.w),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search doctors...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF339CFF)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
                fillColor: const Color(0xFFF7F9FC),
              ),
            ),
          ),

          // Specialty Filter Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: 6,
              itemBuilder: (context, i) {
                final specialties = ["All", "Cardiology", "Neurologist", "Pediatrician", "Orthopedist", "Dermatologist"];
                final spec = specialties[i];
                final isSelected = _selectedSpecialty == spec;

                return GestureDetector(
                  onTap: () => setState(() => _selectedSpecialty = spec),
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF339CFF) : const Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      spec,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : const Color(0xFF2E2E2E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Dynamic Doctor List
          Expanded(
            child: doctorsAsync.when(
              data: (doctors) {
                if (doctors.isEmpty) {
                  return const Center(child: Text("No doctors available at the moment"));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doc = doctors[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: DoctorDetails(doctorId: doc["id"]),
                          ),
                        );
                      },
                      child: doctorList(
                        image: doc["image_url"] ?? "assets/images/male-doctor.png",
                        maintext: doc["name"] ?? "Dr. Unknown",
                        subtext: doc["specialty"] ?? "Specialist",
                        numRating: doc["rating"]?.toString() ?? "4.5",
                        distance: doc["distance"] ?? "1km Away",
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text("Failed to load doctors: $error"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}