// screens/doctor_search.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Widgets/doctorList.dart';
import 'doctor_details_screen.dart';

class DoctorSearch extends StatefulWidget {
  const DoctorSearch({super.key});

  @override
  State<DoctorSearch> createState() => _DoctorSearchState();
}

class _DoctorSearchState extends State<DoctorSearch> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = "All";
  String _searchQuery = "";

  // 13 DOCTORS — DIFFERENT SPECIALTIES
  final List<Map<String, String>> _doctors = [
    {"image": "assets/images/male-doctor.png", "name": "Dr. Marcus Horizon", "specialty": "Cardiologist", "rating": "4.7", "distance": "800m Away"},
    {"image": "assets/images/docto3.png", "name": "Dr. Maria Elena", "specialty": "Psychologist", "rating": "4.6", "distance": "1.2km Away"},
    {"image": "assets/images/doctor2.png", "name": "Dr. Stevi Jessi", "specialty": "Orthopedist", "rating": "4.8", "distance": "2km Away"},
    {"image": "assets/images/black-doctor.png", "name": "Dr. James Carter", "specialty": "Neurologist", "rating": "4.9", "distance": "1.5km Away"},
    {"image": "assets/images/male-doctor.png", "name": "Dr. Sarah Kim", "specialty": "Pediatrician", "rating": "4.5", "distance": "900m Away"},
    {"image": "assets/images/docto3.png", "name": "Dr. Ahmed Ali", "specialty": "Dermatologist", "rating": "4.7", "distance": "1.1km Away"},
    {"image": "assets/images/doctor2.png", "name": "Dr. Lisa Wong", "specialty": "Gynecologist", "rating": "4.8", "distance": "2.3km Away"},
    {"image": "assets/images/black-doctor.png", "name": "Dr. Raj Patel", "specialty": "General Surgeon", "rating": "4.9", "distance": "1.8km Away"},
    {"image": "assets/images/male-doctor.png", "name": "Dr. Emily Brown", "specialty": "Endocrinologist", "rating": "4.6", "distance": "700m Away"},
    {"image": "assets/images/docto3.png", "name": "Dr. Michael Lee", "specialty": "Urologist", "rating": "4.7", "distance": "1.4km Away"},
    {"image": "assets/images/doctor2.png", "name": "Dr. Fatima Khan", "specialty": "Ophthalmologist", "rating": "4.8", "distance": "1.9km Away"},
    {"image": "assets/images/black-doctor.png", "name": "Dr. Carlos Ruiz", "specialty": "ENT Specialist", "rating": "4.5", "distance": "1.0km Away"},
    {"image": "assets/images/male-doctor.png", "name": "Dr. Olivia Chen", "specialty": "Rheumatologist", "rating": "4.7", "distance": "1.3km Away"},
  ];

  List<Map<String, String>> get _filteredDoctors {
    return _doctors.where((doc) {
      final matchesSearch = doc["name"]!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc["specialty"]!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedSpecialty == "All" || doc["specialty"] == _selectedSpecialty;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final specialties = ["All", ..._doctors.map((d) => d["specialty"]!).toSet()];

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
        title: Text("Top Doctors", style: GoogleFonts.poppins(fontSize: 18.sp, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Image.asset("assets/images/more.png", width: 24, height: 24),
          ),
        ],
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: EdgeInsets.all(5.w),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "Search doctors...",
                prefixIcon: Icon(Icons.search, color: Color(0xFF339CFF)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
                fillColor: Color(0xFFF7F9FC),
              ),
            ),
          ),

          // FILTER CHIPS
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: specialties.length,
              itemBuilder: (context, i) {
                final spec = specialties[i];
                final isSelected = _selectedSpecialty == spec;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSpecialty = spec),
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF339CFF) : Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      spec,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : Color(0xFF2E2E2E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // DOCTOR LIST
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                final doc = _filteredDoctors[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: DoctorDetails(doctor: doc),
                      ),
                    );
                  },
                  child: doctorList(
                    image: doc["image"]!,
                    maintext: doc["name"]!,
                    subtext: doc["specialty"]!,
                    numRating: doc["rating"]!,
                    distance: doc["distance"]!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}