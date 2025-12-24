import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/response_object.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/sign_up_entity.dart';

part 'registration_provider.g.dart';

@riverpod
class Registration extends _$Registration {
  @override
  AsyncValue<SignUpResponseEntity?> build() {
    return const AsyncValue.data(null);
  }

  void register({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final request = SignUpRequestEntity(
        name: name,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );

      final response = await ref.read(registerUseCaseProvider).call(request);

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
}

