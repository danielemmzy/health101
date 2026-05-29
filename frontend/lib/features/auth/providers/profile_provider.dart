// lib/features/profile/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

// Main profile data provider
final profileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return await repository.getProfile();
});

// Update profile provider
final profileUpdateProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository, ref); // ← Pass ref here
});

class ProfileNotifier extends StateNotifier<AsyncValue<bool>> {
  final ProfileRepository _repository;
  final Ref _ref; // ← Add this

  ProfileNotifier(this._repository, this._ref) : super(const AsyncValue.data(false));

  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? address,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(
        fullName: fullName,
        phone: phone,
        address: address,
      );
      state = const AsyncValue.data(true);
      
      // Refresh profile data
      _ref.invalidate(profileProvider);   // ← Now works

      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
}