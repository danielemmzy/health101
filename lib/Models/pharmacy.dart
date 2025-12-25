// models/pharmacy.dart
class Pharmacy {
  final String id;           // REQUIRED for Hero
  final String imagePath;
  final String name;
  final String address;
  final double rating;
  final String openUntil;
  final String phone;        // For "Call" button
  final String distance;     // For "X km away"

  Pharmacy({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.address,
    required this.rating,
    required this.openUntil,
    required this.phone,
    required this.distance,
  });
}