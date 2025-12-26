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
ImageUploadService imageUploadService(Ref ref) {
  return ImageUploadService(ref.read(dioProvider), baseUrl: Endpoints.base);
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
ProgressService progressService(Ref ref) {
  return ProgressService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
PracticeSessionService practiceSessionService(Ref ref) {
  return PracticeSessionService(ref.read(dioProvider), baseUrl: Endpoints.base);
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
  // Always use real services (no mock)
  // Composite service routes to the appropriate provider (Google/Apple)
  return CompositeOAuthService(
    googleService: ref.read(googleOAuthServiceProvider),
    appleService: ref.read(appleOAuthServiceProvider),
  );
}

@riverpod
GoogleOAuthService googleOAuthService(Ref ref) {
  return GoogleOAuthService();
}

@riverpod
AppleOAuthService appleOAuthService(Ref ref) {
  return AppleOAuthService();
}
