import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/doctor_repository.dart';

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  return DoctorRepository();
});

final topDoctorsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.watch(doctorRepositoryProvider);
  return await repository.getTopDoctors(limit: 10);
});

final doctorDetailProvider = FutureProvider.family<Map<String, dynamic>, int>(
  (ref, doctorId) async {
    final repository = ref.watch(doctorRepositoryProvider);
    return await repository.getDoctorDetail(doctorId);
  },
);