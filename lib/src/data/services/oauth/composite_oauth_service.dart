import 'oauth_service.dart';
import 'google_oauth_service.dart';
import 'apple_oauth_service.dart';

/// Composite OAuth service that routes to the appropriate provider
/// This allows a single OAuthService instance to handle both Google and Apple
class CompositeOAuthService implements OAuthService {
  CompositeOAuthService({
    required GoogleOAuthService googleService,
    required AppleOAuthService appleService,
  })  : _googleService = googleService,
        _appleService = appleService;

  final GoogleOAuthService _googleService;
  final AppleOAuthService _appleService;

  @override
  Future<String?> signInWithGoogle() async {
    return _googleService.signInWithGoogle();
  }

  @override
  Future<String?> signInWithApple() async {
    return _appleService.signInWithApple();
  }
}

