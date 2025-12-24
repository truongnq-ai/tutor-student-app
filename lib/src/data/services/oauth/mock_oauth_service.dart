import 'dart:math';
import 'oauth_service.dart';

/// Mock OAuth service for development/testing
class MockOAuthService implements OAuthService {
  @override
  Future<String?> signInWithGoogle() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));
    
    // Return a fake ID token
    final random = Random();
    final token = 'mock_google_token_${random.nextInt(10000)}';
    return token;
  }

  @override
  Future<String?> signInWithApple() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 1));
    
    // Return a fake ID token
    final random = Random();
    final token = 'mock_apple_token_${random.nextInt(10000)}';
    return token;
  }
}

