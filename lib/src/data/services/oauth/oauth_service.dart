/// Interface for OAuth authentication services
abstract class OAuthService {
  /// Sign in with Google and return ID token
  Future<String?> signInWithGoogle();

  /// Sign in with Apple and return ID token
  Future<String?> signInWithApple();
}

