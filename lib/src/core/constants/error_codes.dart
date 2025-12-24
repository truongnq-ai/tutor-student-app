/// Error codes constants matching backend specification
/// 
/// Error code ranges:
/// - 0000: Success
/// - 0001-0999: Business errors
/// - 1000-1999: Authentication & Authorization errors
/// - 2000-2999: Validation errors
/// - 3000-3999: Resource errors
/// - 4000-4999: Service integration errors
/// - 5000-5999: System errors
class ErrorCodes {
  // Success
  static const String success = '0000';

  // Business errors (0001-0999)
  static const String businessError = '0001';

  // Authentication & Authorization errors (1000-1999)
  static const String unauthorized = '1001';
  static const String tokenExpired = '1002';
  static const String forbidden = '1003';
  static const String phoneNotVerified = '1004';

  // Validation errors (2000-2999)
  static const String validationError = '2001';
  static const String missingField = '2002';
  static const String invalidFormat = '2003';
  static const String otpInvalid = '2004';
  static const String otpExpired = '2005';
  static const String recaptchaFailed = '2006';

  // Resource errors (3000-3999)
  static const String notFound = '3001';
  static const String conflict = '3002';
  static const String questionNotFound = '3003';
  static const String questionNotAssigned = '3004';
  static const String questionAlreadyCompleted = '3005';
  static const String questionStudentMismatch = '3006';
  static const String exerciseNotApproved = '3007';

  // Service integration errors (4000-4999)
  static const String serviceUnavailable = '4001';
  static const String aiServiceUnavailable = '4002';

  // System errors (5000-5999)
  static const String internalError = '5001';
  static const String databaseError = '5002';
  static const String networkError = '5003';

  // Special error codes from API spec
  static const String trialExpired = '4030';
  static const String skillNotUnlocked = '4031';
  static const String prerequisiteNotMet = '4032';
  static const String rateLimitExceeded = '4290';

  /// Check if error code is in a specific range
  static bool isBusinessError(String code) {
    final num = int.tryParse(code);
    return num != null && num >= 1 && num <= 999;
  }

  static bool isAuthError(String code) {
    final num = int.tryParse(code);
    return num != null && num >= 1000 && num <= 1999;
  }

  static bool isValidationError(String code) {
    final num = int.tryParse(code);
    return num != null && num >= 2000 && num <= 2999;
  }

  static bool isResourceError(String code) {
    final num = int.tryParse(code);
    return num != null && num >= 3000 && num <= 3999;
  }

  static bool isServiceError(String code) {
    final num = int.tryParse(code);
    return num != null && num >= 4000 && num <= 4999;
  }

  static bool isSystemError(String code) {
    final num = int.tryParse(code);
    return num != null && num >= 5000 && num <= 5999;
  }
}

