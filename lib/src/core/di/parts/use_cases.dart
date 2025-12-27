part of '../dependency_injection.dart';

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
OAuthLoginUseCase oauthLoginUseCase(Ref ref) {
  return OAuthLoginUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
SetCredentialUseCase setCredentialUseCase(Ref ref) {
  return SetCredentialUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
GetCurrentLocaleUseCase getCurrentLocaleUseCase(Ref ref) {
  return GetCurrentLocaleUseCase(ref.read(localeRepositoryProvider));
}

@riverpod
SetCurrentLocaleUseCase setCurrentLocaleUseCase(Ref ref) {
  return SetCurrentLocaleUseCase(ref.read(localeRepositoryProvider));
}

@riverpod
ResetRepositoryUseCase resetRepositoryUseCase(Ref ref) {
  return const ResetRepositoryUseCase();
}

@riverpod
GetOnboardingStatusUseCase getOnboardingStatusUseCase(Ref ref) {
  return GetOnboardingStatusUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
GetUserLoginStatusUseCase getUserLoginStatusUseCase(Ref ref) {
  return GetUserLoginStatusUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
MarkOnboardingCompletedUseCase markOnboardingCompletedUseCase(Ref ref) {
  return MarkOnboardingCompletedUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
GetTrialStatusUseCase getTrialStatusUseCase(Ref ref) {
  return GetTrialStatusUseCase(ref.read(trialRepositoryProvider));
}

@riverpod
GetGradeUseCase getGradeUseCase(Ref ref) {
  return GetGradeUseCase(ref.read(onboardingRepositoryProvider));
}

@riverpod
GetLearningGoalsUseCase getLearningGoalsUseCase(Ref ref) {
  return GetLearningGoalsUseCase(ref.read(onboardingRepositoryProvider));
}

@riverpod
RequestOtpUseCase requestOtpUseCase(Ref ref) {
  return RequestOtpUseCase(ref.read(parentLinkingRepositoryProvider));
}

@riverpod
VerifyOtpUseCase verifyOtpUseCase(Ref ref) {
  return VerifyOtpUseCase(ref.read(parentLinkingRepositoryProvider));
}

@riverpod
ResendOtpUseCase resendOtpUseCase(Ref ref) {
  return ResendOtpUseCase(ref.read(parentLinkingRepositoryProvider));
}
