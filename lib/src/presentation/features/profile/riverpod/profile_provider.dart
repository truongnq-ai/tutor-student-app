import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/profile_entity.dart';

part 'profile_provider.g.dart';

@riverpod
class Profile extends _$Profile {
  @override
  Future<ProfileEntity?> build() async {
    return null;
  }

  Future<void> loadProfile() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(profileRepositoryProvider).getProfile();

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(profileRepositoryProvider).updateProfile(
            name: name,
            avatarUrl: avatarUrl,
          );

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<String?> uploadAvatar(String imagePath) async {
    try {
      final response = await ref.read(profileRepositoryProvider).uploadAvatar(imagePath);

      if (response.isSuccess && response.data != null) {
        // Update profile with new avatar URL
        await updateProfile(avatarUrl: response.data);
        return response.data;
      } else {
        final errorMessage = response.getErrorMessage();
        throw Exception(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

