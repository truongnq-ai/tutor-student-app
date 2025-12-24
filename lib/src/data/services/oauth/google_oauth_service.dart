import 'package:google_sign_in/google_sign_in.dart';
import 'oauth_service.dart';

/// Google OAuth service implementation
class GoogleOAuthService implements OAuthService {
  GoogleOAuthService({
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ?? GoogleSignIn();

  final GoogleSignIn _googleSignIn;

  @override
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        // User cancelled the sign-in
        return null;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      return auth.idToken;
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  @override
  Future<String?> signInWithApple() {
    throw UnimplementedError('Apple sign-in not implemented in GoogleOAuthService');
  }
}

