// lib/features/pharmacy/providers/pharmacy_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/pharmacy_repository.dart';

final pharmacyRepositoryProvider = Provider<PharmacyRepository>((ref) {
  return PharmacyRepository();
});

// Simple provider (not family) for nearby pharmacies
final nearbyPharmaciesProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(pharmacyRepositoryProvider);
  return await repo.getNearbyPharmacies(
    lat: 6.5244,
    lon: 3.3792,
  );
});

// Provider for single pharmacy detail
final pharmacyDetailProvider = FutureProvider.family<Map<String, dynamic>, int>(
  (ref, pharmacyId) async {
    final repository = ref.watch(pharmacyRepositoryProvider);
    return await repository.getPharmacyById(pharmacyId);
  },
);