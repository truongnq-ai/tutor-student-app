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
  
  static const String trialStart = '/api/v1/student/trial/start';
  static const String trialStatus = '/api/v1/student/trial/status';
  
  /// Grade & Learning Goals
  static const String studentSaveGrade = '/api/v1/student/grade';
  static const String studentGetGrade = '/api/v1/student/grade';
  static const String studentSaveLearningGoals = '/api/v1/student/learning-goals';
  static const String studentGetLearningGoals = '/api/v1/student/learning-goals';

  // ==================== Tutor Mode ====================
  
  static const String tutorSolveImage = '/api/tutor/solve/image';
  static const String tutorSolveText = '/api/tutor/solve/text';

  // ==================== Learning & Practice ====================
  
  static const String learningToday = '/api/v1/learning/today';
  static const String learningWeakSkills = '/api/v1/learning/weak-skills';
  static const String practiceSubmit = '/api/v1/practice/submit';
  static const String practiceHistory = '/api/v1/practice/history';
  static const String practiceSessionInfo = '/api/v1/practice/sessions/{sessionId}';
  
  /// Practice Questions (new API)
  static const String practiceQuestions = '/api/practice/questions';
  static const String practiceQuestionDetail = '/api/practice/questions/{id}';
  static const String practiceQuestionSubmit = '/api/practice/questions/{id}/submit';

  // ==================== Mini Test ====================
  
  static const String miniTestStart = '/api/minitest/start';
  static const String miniTestSubmit = '/api/minitest/submit';

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
