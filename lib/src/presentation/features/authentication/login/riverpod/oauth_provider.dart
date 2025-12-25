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
      try {
        if (provider == 'google') {
          idToken = await oauthService.signInWithGoogle();
        } else if (provider == 'apple') {
          idToken = await oauthService.signInWithApple();
        } else {
          throw Exception('Nhà cung cấp đăng nhập không được hỗ trợ: $provider');
        }
      } catch (e) {
        // Handle OAuth provider errors (network, user cancellation, etc.)
        if (e.toString().contains('cancelled') || 
            e.toString().contains('canceled') ||
            e.toString().contains('user_cancelled')) {
          // User cancelled - don't show error, just reset state
          state = const AsyncValue.data(null);
          return;
        }
        // Re-throw other OAuth errors with user-friendly message
        throw Exception('Không thể kết nối với ${provider == 'google' ? 'Google' : 'Apple'}. Vui lòng thử lại.');
      }

      if (idToken == null) {
        // User cancelled - don't show error
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
        // Provide user-friendly error message
        final friendlyMessage = _getUserFriendlyErrorMessage(errorMessage);
        state = AsyncValue.error(
          Exception(friendlyMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      // Handle network errors, timeout, etc.
      final errorMessage = _getUserFriendlyErrorMessage(e.toString());
      state = AsyncValue.error(
        Exception(errorMessage),
        stackTrace,
      );
    }
  }

  String _getUserFriendlyErrorMessage(String errorMessage) {
    // Map technical errors to user-friendly messages
    if (errorMessage.contains('timeout') || errorMessage.contains('TimeoutException')) {
      return 'Kết nối quá lâu. Vui lòng kiểm tra internet và thử lại.';
    }
    if (errorMessage.contains('network') || errorMessage.contains('NetworkException')) {
      return 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
    }
    if (errorMessage.contains('401') || errorMessage.contains('UNAUTHORIZED')) {
      return 'Xác thực thất bại. Vui lòng thử lại.';
    }
    if (errorMessage.contains('400') || errorMessage.contains('VALIDATION_ERROR')) {
      return 'Thông tin đăng nhập không hợp lệ. Vui lòng thử lại.';
    }
    if (errorMessage.contains('500') || errorMessage.contains('INTERNAL_SERVER_ERROR')) {
      return 'Lỗi hệ thống. Vui lòng thử lại sau.';
    }
    // Return original message if no mapping found, but remove technical prefixes
    return errorMessage.replaceFirst('Exception: ', '').replaceFirst('Error: ', '');
  }
}

