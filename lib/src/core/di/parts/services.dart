part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return SharedPreferencesService(
    ref.read(sharedPreferencesProvider).requireValue,
  );
}

@riverpod
RestClient restClientService(Ref ref) {
  return RestClient(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
StudentService studentService(Ref ref) {
  return StudentService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
TutorService tutorService(Ref ref) {
  return TutorService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
LearningService learningService(Ref ref) {
  return LearningService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
PracticeService practiceService(Ref ref) {
  return PracticeService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
MiniTestService miniTestService(Ref ref) {
  return MiniTestService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
LinkingService linkingService(Ref ref) {
  return LinkingService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
OAuthService oauthService(Ref ref) {
  // Use mock in development, real services in production
  // Note: In production, you may want to use a factory that returns
  // the appropriate service based on platform or configuration
  if (Env.isDevelopment) {
    return MockOAuthService();
  } else {
    // In production, return GoogleOAuthService as default
    // You can inject AppleOAuthService separately if needed
    return GoogleOAuthService();
  }
}

@riverpod
GoogleOAuthService googleOAuthService(Ref ref) {
  return GoogleOAuthService();
}

@riverpod
AppleOAuthService appleOAuthService(Ref ref) {
  return AppleOAuthService();
}
