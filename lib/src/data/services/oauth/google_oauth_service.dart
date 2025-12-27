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
      print('[GoogleOAuthService] Starting Google Sign-In...');
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        print('[GoogleOAuthService] User cancelled Google Sign-In');
        return null;
      }

      print('[GoogleOAuthService] Google Sign-In successful, getting authentication...');
      print('[GoogleOAuthService] Account email: ${account.email}');
      final GoogleSignInAuthentication auth = await account.authentication;
      print('[GoogleOAuthService] Got ID token: ${auth.idToken != null ? 'Yes (${auth.idToken!.length} chars)' : 'No'}');
      print('[GoogleOAuthService] Got access token: ${auth.accessToken != null ? 'Yes' : 'No'}');
      return auth.idToken;
    } catch (e, stackTrace) {
      print('[GoogleOAuthService] Google Sign-In error: $e');
      print('[GoogleOAuthService] Error type: ${e.runtimeType}');
      print('[GoogleOAuthService] Stack trace: $stackTrace');
      throw Exception('Google sign-in failed: $e');
    }
  }

  @override
  Future<String?> signInWithApple() {
    throw UnimplementedError('Apple sign-in not implemented in GoogleOAuthService');
  }
}

