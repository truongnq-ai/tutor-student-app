import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/di/dependency_injection.dart';

part 'oauth_provider.g.dart';

/// Provider to track which OAuth provider is currently loading
@riverpod
class OAuthLoadingProvider extends _$OAuthLoadingProvider {
  @override
  String? build() {
    return null; // null means no provider is loading
  }

  void setLoading(String? provider) {
    state = provider;
  }
}

@riverpod
class OAuthLogin extends _$OAuthLogin {
  @override
  AsyncValue<Map<String, dynamic>?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> loginWithOAuth(String provider) async {
    // Check if any provider is already loading
    final loadingProvider = ref.read(oAuthLoadingProviderProvider);
    if (loadingProvider != null) return;

    // Set loading provider
    ref.read(oAuthLoadingProviderProvider.notifier).setLoading(provider);
    state = const AsyncValue.loading();

    try {
      // Get OAuth service
      final oauthService = ref.read(oauthServiceProvider);

      // Get ID token from OAuth provider
      String? idToken;
      try {
        if (provider == 'google') {
          idToken = await oauthService.signInWithGoogle();
        } else if (provider == 'apple') {
          idToken = await oauthService.signInWithApple();
        } else {
          throw Exception(
            'Nhà cung cấp đăng nhập không được hỗ trợ: $provider',
          );
        }
      } catch (e, stackTrace) {
        // Clear loading provider
        ref.read(oAuthLoadingProviderProvider.notifier).setLoading(null);

        // Log the original exception for debugging
        print('[OAuthProvider] OAuth error for $provider: $e');
        print('[OAuthProvider] Error type: ${e.runtimeType}');
        print('[OAuthProvider] Stack trace: $stackTrace');

        // Handle OAuth provider errors (network, user cancellation, etc.)
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('cancelled') ||
            errorString.contains('canceled') ||
            errorString.contains('user_cancelled')) {
          // User cancelled - don't show error, just reset state
          print('[OAuthProvider] User cancelled $provider sign-in');
          state = const AsyncValue.data(null);
          return;
        }

        // Check for specific Google Sign-In errors
        if (provider == 'google') {
          if (errorString.contains('sign_in_failed') ||
              errorString.contains('platform_exception') ||
              errorString.contains('missing_client_id') ||
              errorString.contains('sign_in_required') ||
              errorString.contains('network_error')) {
            print(
              '[OAuthProvider] Google Sign-In configuration or network error detected',
            );
            throw Exception(
              'Google Sign-In chưa được cấu hình đúng hoặc lỗi kết nối. Vui lòng kiểm tra cài đặt.',
            );
          }
        }

        // Re-throw with more detailed error message for debugging
        final originalMessage = e.toString().replaceFirst('Exception: ', '');
        // Keep original error in log but show user-friendly message
        print('[OAuthProvider] Original error message: $originalMessage');
        throw Exception(
          'Không thể kết nối với ${provider == 'google' ? 'Google' : 'Apple'}. Vui lòng thử lại.',
        );
      }

      if (idToken == null) {
        // Clear loading provider
        ref.read(oAuthLoadingProviderProvider.notifier).setLoading(null);
        // User cancelled - don't show error
        state = const AsyncValue.data(null);
        return;
      }

      // Call OAuth login API
      final response = await ref
          .read(oauthLoginUseCaseProvider)
          .call(provider: provider, idToken: idToken);

      if (response.isSuccess && response.data != null) {
        // Clear loading provider
        ref.read(oAuthLoadingProviderProvider.notifier).setLoading(null);
        // Tokens are already saved by repository during oauthLogin call
        state = AsyncValue.data(response.data);
      } else {
        // Clear loading provider
        ref.read(oAuthLoadingProviderProvider.notifier).setLoading(null);
        final errorMessage = response.getErrorMessage();
        // Provide user-friendly error message
        final friendlyMessage = _getUserFriendlyErrorMessage(errorMessage);
        state = AsyncValue.error(
          Exception(friendlyMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      // Clear loading provider
      ref.read(oAuthLoadingProviderProvider.notifier).setLoading(null);

      // Log the error for debugging
      print('[OAuthProvider] Unexpected error during OAuth login: $e');
      print('[OAuthProvider] Error type: ${e.runtimeType}');
      print('[OAuthProvider] Stack trace: $stackTrace');

      // Handle network errors, timeout, etc.
      final errorMessage = _getUserFriendlyErrorMessage(e.toString());
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
    }
  }

  String _getUserFriendlyErrorMessage(String errorMessage) {
    final lowerError = errorMessage.toLowerCase();

    // Map technical errors to user-friendly messages
    if (lowerError.contains('timeout') ||
        lowerError.contains('timeoutexception')) {
      return 'Kết nối quá lâu. Vui lòng kiểm tra internet và thử lại.';
    }
    if (lowerError.contains('network') ||
        lowerError.contains('networkexception') ||
        lowerError.contains('socketexception') ||
        lowerError.contains('connection')) {
      return 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
    }
    if (lowerError.contains('401') || lowerError.contains('unauthorized')) {
      return 'Xác thực thất bại. Vui lòng thử lại.';
    }
    if (lowerError.contains('400') ||
        lowerError.contains('validation_error') ||
        lowerError.contains('bad request')) {
      return 'Thông tin đăng nhập không hợp lệ. Vui lòng thử lại.';
    }
    if (lowerError.contains('500') ||
        lowerError.contains('internal_server_error')) {
      return 'Lỗi hệ thống. Vui lòng thử lại sau.';
    }
    if (lowerError.contains('sign_in_failed') ||
        lowerError.contains('platform_exception') ||
        lowerError.contains('missing_client_id')) {
      return 'Google Sign-In chưa được cấu hình đúng. Vui lòng liên hệ hỗ trợ.';
    }

    // Log original error for debugging
    print('[OAuthProvider] Unmapped error message: $errorMessage');

    // Return original message if no mapping found, but remove technical prefixes
    return errorMessage
        .replaceFirst('Exception: ', '')
        .replaceFirst('Error: ', '')
        .replaceFirst('Google sign-in failed: ', '');
  }
}
