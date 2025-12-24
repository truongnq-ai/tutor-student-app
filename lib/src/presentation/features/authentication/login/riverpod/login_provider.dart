import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/login_entity.dart';

part 'login_provider.g.dart';

@riverpod
class Login extends _$Login {
  @override
  AsyncValue<LoginResponseEntity?> build() {
    return const AsyncValue.data(null);
  }

  void login({
    required String username,
    required String password,
    bool? shouldRemember,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref
          .read(loginUseCaseProvider)
          .call(
            username: username,
            password: password,
            shouldRemember: shouldRemember,
          );

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        // Handle error - check errorCode
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
}
