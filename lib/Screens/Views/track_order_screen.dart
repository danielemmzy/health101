// screens/track_order_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderId;
  const TrackOrderScreen({super.key, required this.orderId});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  final MapController _mapController = MapController();

  // Simulated delivery positions
  final LatLng _pharmacyLocation = const LatLng(9.0765, 7.3986);
  final LatLng _deliveryLocation = const LatLng(9.0820, 7.4100);
  final LatLng _currentRiderPos = const LatLng(9.0790, 7.4020);

  @override
  void initState() {
    super.initState();
    // Animate map to current rider
    Future.delayed(const Duration(milliseconds: 500), () {
      _mapController.move(_currentRiderPos, 14.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("assets/images/back2.png", width: 28, height: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Track Order",
          style: GoogleFonts.inter(fontSize: 19.sp, fontWeight: FontWeight.w700, color: const Color(0xFF2E2E2E)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TOP: LIVE MAP
          SizedBox(
            height: 48.h,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentRiderPos,
                initialZoom: 14.5,
                minZoom: 10,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.health101.app',
                ),
                MarkerLayer(
                  markers: [
                    // Pharmacy
                    Marker(
                      point: _pharmacyLocation,
                      width: 50,
                      height: 50,
                      child: Icon(Icons.store, color: Colors.green[700], size: 40),
                    ),
                    // Delivery Address
                    Marker(
                      point: _deliveryLocation,
                      width: 50,
                      height: 50,
                      child: Icon(Icons.home, color: Colors.red[700], size: 40),
                    ),
                    // Rider (Live)
                    Marker(
                      point: _currentRiderPos,
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        "assets/images/location_illus.png", // Add this asset
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // BOTTOM: ORDER DETAILS CARD
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: Offset(0, -10)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Header
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF339CFF).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "On the way • Estimated arrival in 12 min",
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF339CFF),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Order ID
                    _buildDetailRow(Icons.confirmation_number, "Order ID", "#${widget.orderId}"),
                    _buildDetailRow(Icons.medication, "Items", "Ibuprofen 400mg × 2, Paracetamol × 1"),
                    _buildDetailRow(Icons.person, "Delivery Partner", "Ahmed Musa"),
                    _buildDetailRow(Icons.phone, "Contact", "+234 801 234 5678"),
                    _buildDetailRow(Icons.location_on, "Delivery Address", "No. 12 Ahmadu Bello Way, Abuja"),

                    SizedBox(height: 4.h),

                    // Progress Steps
                    _buildProgressStep("Order Confirmed", true),
                    _buildProgressStep("Picked Up by Rider", true),
                    _buildProgressStep("On the Way", true),
                    _buildProgressStep("Delivered", false),

                    SizedBox(height: 4.h),

                    // Contact Rider Button
                    SizedBox(
                      width: double.infinity,
                      height: 7.h,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.phone, size: 20.sp),
                        label: Text("Contact Rider", style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF339CFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 8,
                          shadowColor: const Color(0xFF339CFF).withOpacity(0.4),
                        ),
                        onPressed: () {
                          // Call rider
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF339CFF), size: 22.sp),
          SizedBox(width: 3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[600])),
              Text(value, style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String title, bool completed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: completed ? const Color(0xFF339CFF) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: completed ? Icon(Icons.check, color: Colors.white, size: 18) : null,
          ),
          SizedBox(width: 3.w),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: completed ? FontWeight.w600 : FontWeight.w400,
              color: completed ? const Color(0xFF2E2E2E) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}