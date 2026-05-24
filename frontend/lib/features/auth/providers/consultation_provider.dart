import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/consultation_repository.dart';

final consultationRepositoryProvider = Provider<ConsultationRepository>((ref) {
  return ConsultationRepository();
});


// Provider for fetching available doctors for consultation
final availableDoctorsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(consultationRepositoryProvider);
  return await repo.getAvailableDoctors();
});

// Provider for fetching user's consultations
final myConsultationsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(consultationRepositoryProvider);
  return await repo.getMyConsultations();
});