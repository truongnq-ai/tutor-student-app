part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepositoryImpl(
    studentService: ref.read(studentServiceProvider),
    authService: ref.read(authServiceProvider),
    local: ref.read(cacheServiceProvider),
  );
}

@Riverpod(keepAlive: true)
RouterRepository routerRepository(Ref ref) {
  return RouterRepositoryImpl(cacheService: ref.read(cacheServiceProvider));
}

@Riverpod(keepAlive: true)
LocaleRepository localeRepository(Ref ref) {
  return LocaleRepositoryImpl(ref.read(cacheServiceProvider));
}

@Riverpod(keepAlive: true)
TrialRepository trialRepository(Ref ref) {
  return TrialRepositoryImpl(
    studentService: ref.read(studentServiceProvider),
    cacheService: ref.read(cacheServiceProvider),
  );
}

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepositoryImpl(
    studentService: ref.read(studentServiceProvider),
    cacheService: ref.read(cacheServiceProvider),
  );
}

@Riverpod(keepAlive: true)
ParentLinkingRepository parentLinkingRepository(Ref ref) {
  return ParentLinkingRepositoryImpl(
    linkingService: ref.read(linkingServiceProvider),
    cacheService: ref.read(cacheServiceProvider),
  );
}

@Riverpod(keepAlive: true)
LearningRepository learningRepository(Ref ref) {
  return LearningRepositoryImpl(
    learningService: ref.read(learningServiceProvider),
  );
}

@Riverpod(keepAlive: true)
PracticeRepository practiceRepository(Ref ref) {
  return PracticeRepositoryImpl(
    practiceService: ref.read(practiceServiceProvider),
  );
}

@Riverpod(keepAlive: true)
QuestionRepository questionRepository(Ref ref) {
  return QuestionRepositoryImpl(
    practiceService: ref.read(practiceServiceProvider),
  );
}