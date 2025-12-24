import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'oauth_service.dart';

/// Apple OAuth service implementation
class AppleOAuthService implements OAuthService {
  @override
  Future<String?> signInWithGoogle() {
    throw UnimplementedError('Google sign-in not implemented in AppleOAuthService');
  }

  @override
  Future<String?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Return the identity token (ID token)
      return credential.identityToken;
    } catch (e) {
      throw Exception('Apple sign-in failed: $e');
    }
  }
}

