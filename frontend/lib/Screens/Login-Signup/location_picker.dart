import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health101/Screens/Views/Homepage.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:page_transition/page_transition.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});
  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();

  LatLng _markerPos = const LatLng(9.0765, 7.3986);
  List<dynamic> _suggestions = [];
  bool _searching = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _searchLocation(String query) async {
    if (query.isEmpty || query.trim().length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    setState(() => _searching = true);

    final url = Uri.https('photon.komoot.io', '/api/', {
      'q': query.trim(),
      'limit': '6',
      'lang': 'en',
    });

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _suggestions = data['features'] ?? [];
          _searching = false;
        });
      }
    } catch (e) {
      setState(() => _searching = false);
    }
  }

  void _selectPlace(dynamic place) {
    final coords = place['geometry']['coordinates'];
    final lat = coords[1];
    final lng = coords[0];

    setState(() {
      _markerPos = LatLng(lat, lng);
      _suggestions = [];
      _searchCtrl.clear();
    });
    _mapController.move(_markerPos, 15.0);
  }

  // Solid, beautiful button style
  ButtonStyle _solidButtonStyle({required Color bg, required Color fg}) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r), // Finer, modern radius
      ),
      elevation: 4,
      shadowColor: Colors.black26,
      padding: EdgeInsets.symmetric(vertical: 14.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset("assets/images/back2.png"),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Map
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(initialCenter: _markerPos, initialZoom: 6.0),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _markerPos,
                        width: 60.w,
                        height: 60.w,
                        child: Image.asset(
                          'assets/images/location_illus.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // UI Overlay
              Column(
                children: [
                  // Title
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                    child: const Text(
                      'Your location',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0C141C),
                      ),
                    ),
                  ),

                  // Search
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
                          ),
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: _searchLocation,
                            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF4472A0)),
                            decoration: InputDecoration(
                              hintText: 'Search anywhere...',
                              hintStyle: const TextStyle(color: Color(0xFF4472A0)),
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                              suffixIcon: _searching
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF339BFF)),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),

                        // Suggestions
                        if (_suggestions.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(top: 4.h),
                            constraints: BoxConstraints(maxHeight: 220.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _suggestions.length,
                              itemBuilder: (ctx, i) {
                                final p = _suggestions[i]['properties'];
                                final name = p['name'] ?? p['street'] ?? 'Location';
                                final city = p['city'] ?? p['town'] ?? p['village'];
                                final state = p['state'];
                                final country = p['country'];

                                return ListTile(
                                  dense: true,
                                  title: Text(name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                                  subtitle: Text(
                                    [city, state, country].where((e) => e != null).join(', '),
                                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                                  ),
                                  onTap: () => _selectPlace(_suggestions[i]),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Solid, Beautiful Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      children: [
                        // Confirm Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            style: _solidButtonStyle(
                              bg: const Color(0xFF339BFF),
                              fg: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: const Homepage()));
                            },
                            child: Text(
                              'Confirm location',
                              style: TextStyle(fontSize: 16.sp, fontFamily: 'Lexend', fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Change Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            style: _solidButtonStyle(
                              bg: const Color(0xFFE5EDF4),
                              fg: const Color(0xFF0C141C),
                            ),
                            onPressed: () {
                              setState(() {
                                _markerPos = const LatLng(9.0765, 7.3986);
                                _searchCtrl.clear();
                                _suggestions = [];
                              });
                              _mapController.move(_markerPos, 6.0);
                            },
                            child: Text(
                              'Change location',
                              style: TextStyle(fontSize: 16.sp, fontFamily: 'Lexend', fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
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