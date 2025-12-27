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
        // Handle error - use errorCode and errorDetail from ResponseObject
        // The errorDetail should already be user-friendly from repository
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      // Handle unexpected exceptions
      final errorMessage = e is Exception 
          ? e.toString().replaceFirst('Exception: ', '')
          : 'An unexpected error occurred. Please try again.';
      state = AsyncValue.error(
        Exception(errorMessage),
        stackTrace,
      );
    }
  }
}
