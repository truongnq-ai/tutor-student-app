import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/di/dependency_injection.dart';

part 'oauth_provider.g.dart';

@riverpod
class OAuthLogin extends _$OAuthLogin {
  @override
  AsyncValue<Map<String, dynamic>?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> loginWithOAuth(String provider) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      // Get OAuth service
      final oauthService = ref.read(oauthServiceProvider);
      
      // Get ID token from OAuth provider
      String? idToken;
      if (provider == 'google') {
        idToken = await oauthService.signInWithGoogle();
      } else if (provider == 'apple') {
        idToken = await oauthService.signInWithApple();
      } else {
        throw Exception('Unsupported OAuth provider: $provider');
      }

      if (idToken == null) {
        // User cancelled
        state = const AsyncValue.data(null);
        return;
      }

      // Call OAuth login API
      final response = await ref.read(oauthLoginUseCaseProvider).call(
            provider: provider,
            idToken: idToken,
          );

      if (response.isSuccess && response.data != null) {
        // Tokens are already saved by repository during oauthLogin call
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

