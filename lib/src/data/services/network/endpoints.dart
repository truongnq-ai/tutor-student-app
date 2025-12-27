import '../../../core/config/env.dart';

/// API endpoints for Core Service
class Endpoints {
  static String get base => Env.apiBaseUrl;

  // ==================== Authentication ====================
  
  /// Student Authentication
  static const String studentRegister = '/api/v1/student/register';
  static const String studentLogin = '/api/v1/student/login';
  static const String studentOAuthLogin = '/api/v1/student/oauth/login';
  static const String studentSetCredential = '/api/v1/student/set-credential';

  /// Parent Authentication
  static const String parentRegister = '/api/parent/register';
  static const String parentLogin = '/api/parent/login';
  static const String parentOAuthLogin = '/api/parent/oauth/login';
  static const String parentPhoneUpdate = '/api/parent/phone/update';
  static const String parentPhoneVerifyOtp = '/api/parent/phone/verify-otp';

  /// Token Management
  static const String refreshToken = '/api/v1/auth/refresh_token';
  static const String logout = '/api/v1/auth/logout';

  // ==================== Onboarding & Trial ====================
  
  static const String trialCheck = '/api/v1/student/trial/check';
  static const String trialStart = '/api/v1/student/trial/start';
  static const String trialCreate = '/api/v1/student/trial/create';
  static const String trialStatus = '/api/v1/student/trial/status';
  
  /// Grade & Learning Goals
  static const String studentSaveGrade = '/api/v1/student/grade';
  static const String studentGetGrade = '/api/v1/student/grade';
  static const String studentSaveLearningGoals = '/api/v1/student/learning-goals';
  static const String studentGetLearningGoals = '/api/v1/student/learning-goals';

  // ==================== Tutor Mode ====================
  
  static const String tutorSolveImage = '/api/tutor/solve/image';
  static const String tutorSolveText = '/api/tutor/solve/text';
  static const String tutorRecentProblems = '/api/tutor/problems/recent';
  
  // ==================== Image Upload ====================
  
  static const String imageUpload = '/api/v1/images/upload';

  // ==================== Learning & Practice ====================
  
  static const String learningToday = '/api/v1/learning/today';
  static const String learningWeakSkills = '/api/v1/learning/weak-skills';
  static const String practiceHistory = '/api/v1/practice/history';
  static const String practiceSessionInfo = '/api/v1/practice/session-info/{sessionId}';
  
  /// Practice Questions (new API)
  static const String practiceQuestions = '/api/v1/practice/questions';
  static const String practiceQuestionDetail = '/api/v1/practice/questions/{id}';
  static const String practiceQuestionSubmit = '/api/v1/practice/questions/{id}/submit';

  // ==================== Progress & Mini Test ====================
  
  /// Progress Dashboard
  static const String progressDashboard = '/api/v1/progress/dashboard';
  static const String progressSkillDetail = '/api/v1/progress/skills/{skillId}';
  static const String progressWeakSkills = '/api/v1/progress/weak-skills';
  static const String progressRecommendations = '/api/v1/progress/recommendations';
  
  /// Practice Session
  static const String practiceSessionCreate = '/api/v1/practice/sessions';
  static const String practiceSessionGet = '/api/v1/practice/sessions/{sessionId}';
  static const String practiceSessionQuestions = '/api/v1/practice/sessions/{sessionId}/questions';
  static const String practiceSessionPause = '/api/v1/practice/sessions/{sessionId}/pause';
  static const String practiceSessionResume = '/api/v1/practice/sessions/{sessionId}/resume';
  static const String practiceSessionComplete = '/api/v1/practice/sessions/{sessionId}/complete';
  static const String practiceSessionCancel = '/api/v1/practice/sessions/{sessionId}';
  static const String practiceSessionResumable = '/api/v1/practice/sessions/resumable';
  
  /// Mini Test
  static const String miniTestStart = '/api/v1/minitest/start';
  static const String miniTestSessionGet = '/api/v1/minitest/sessions/{sessionId}';
  static const String miniTestSubmitAnswer = '/api/v1/minitest/sessions/{sessionId}/answer';
  static const String miniTestSubmit = '/api/v1/minitest/sessions/{sessionId}/submit';
  static const String miniTestUnlock = '/api/v1/minitest/unlock/{skillId}';

  // ==================== Profile & Settings ====================
  
  /// Profile
  static const String studentProfileGet = '/api/v1/student/profile/me';
  static const String studentProfileUpdate = '/api/v1/student/profile';
  static const String studentProfileAvatar = '/api/v1/student/profile/avatar';
  
  /// Settings
  static const String studentSettingsGet = '/api/v1/student/settings';
  static const String studentSettingsUpdate = '/api/v1/student/settings';
  
  /// Change Password
  static const String studentChangePassword = '/api/v1/student/change-password';

  // ==================== Parent Linking ====================
  
  static const String linkRequestOtp = '/api/v1/student/parent/link/request-otp';
  static const String linkVerifyOtp = '/api/v1/student/parent/link/verify-otp';
  static const String linkResendOtp = '/api/v1/student/parent/link/resend-otp';

  // ==================== Parent Dashboard ====================
  
  /// Student Management
  static const String parentStudentCreate = '/api/parent/student/create';
  static const String parentStudentStatus = '/api/parent/student/status';

  /// Reporting
  static const String reportSummary = '/api/report/summary';
  static const String reportWeakSkills = '/api/report/weak-skills';
  static const String reportProgress = '/api/report/progress';

  // ==================== Internal APIs ====================
  
  static const String internalLearningGenerateQuestions = '/api/internal/learning/generate-questions';
}
