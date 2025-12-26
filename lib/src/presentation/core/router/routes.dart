class Routes {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String trialStart = '/trial-start';
  static const String selectGrade = '/select-grade';
  static const String selectLearningGoal = '/select-learning-goal';
  static const String trialStatus = '/trial-status';
  static const String trialExpiry = '/trial-expiry';
  static const String otpVerification = '/otp-verification';
  static const String linkingSuccess = '/linking-success';
  static const String onboarding = '/onboarding';
  static const String authEntry = '/auth-entry';

  static const String login = '/login';
  static const String resetPassword = 'reset-password';
  static const String emailVerification = 'email-verification';
  static const String createNewPassword = 'create-new-password';
  static const String resetPasswordSuccess = 'reset-password-success';
  static const String registration = 'registration';
  static const String setCredential = 'set-credential';

  static const String home = '/home';
  static const String profile = '/profile';

  // Learning Flow Routes
  static const String todayLearningPlan = '/learning/today';
  static const String practiceQuestion = '/practice/question';
  static const String practiceResult = '/practice/result';
  static const String practiceSessionComplete = '/practice/session-complete';
  static const String skillSelection = '/practice/skill-selection';
  static const String practiceHistory = '/practice/history';
  static const String sessionResume = '/practice/session-resume';

  // Mini Test Routes (placeholder - will be implemented later)
  static const String miniTestStart = '/minitest/start';

  // Tutor Mode Routes
  static const String tutorModeEntry = '/tutor';
  static const String tutorCameraCapture = '/tutor/camera';
  static const String tutorTextInput = '/tutor/text';
  static const String tutorOcrConfirmation = '/tutor/ocr-confirmation';
  static const String tutorSolution = '/tutor/solution';
  static const String tutorSolutionComplete = '/tutor/solution-complete';
  static const String tutorRecentProblems = '/tutor/recent';
}
