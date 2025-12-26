import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';

part 'password_provider.g.dart';

@riverpod
class ChangePassword extends _$ChangePassword {
  @override
  Future<bool?> build() async {
    return null;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(passwordRepositoryProvider).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
          );

      if (response.isSuccess) {
        state = const AsyncValue.data(true);
        return true;
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return false;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

