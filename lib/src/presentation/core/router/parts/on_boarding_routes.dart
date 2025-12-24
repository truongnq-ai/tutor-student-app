part of '../router.dart';

List<GoRoute> _onboardingRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.splash,
      name: Routes.splash,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: SplashPage());
      },
    ),
    GoRoute(
      path: Routes.welcome,
      name: Routes.welcome,
      pageBuilder: (context, state) {
        return const MaterialPage(child: WelcomePage());
      },
    ),
    GoRoute(
      path: Routes.trialStart,
      name: Routes.trialStart,
      pageBuilder: (context, state) {
        return const MaterialPage(child: TrialStartPage());
      },
    ),
    GoRoute(
      path: Routes.selectGrade,
      name: Routes.selectGrade,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SelectGradePage());
      },
    ),
    GoRoute(
      path: Routes.selectLearningGoal,
      name: Routes.selectLearningGoal,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SelectLearningGoalPage());
      },
    ),
    GoRoute(
      path: Routes.trialStatus,
      name: Routes.trialStatus,
      pageBuilder: (context, state) {
        return const MaterialPage(child: TrialStatusPage());
      },
    ),
    GoRoute(
      path: Routes.trialExpiry,
      name: Routes.trialExpiry,
      pageBuilder: (context, state) {
        return const MaterialPage(child: TrialExpiryPage());
      },
    ),
    GoRoute(
      path: Routes.otpVerification,
      name: Routes.otpVerification,
      pageBuilder: (context, state) {
        return const MaterialPage(child: OtpVerificationPage());
      },
    ),
    GoRoute(
      path: Routes.linkingSuccess,
      name: Routes.linkingSuccess,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LinkingSuccessPage());
      },
    ),
    GoRoute(
      path: Routes.onboarding,
      name: Routes.onboarding,
      pageBuilder: (context, state) {
        return const MaterialPage(child: OnboardingPage());
      },
    ),
  ];
}
