/// Mini Test configuration constants
/// These should match backend constants in MiniTestServiceImpl.java
/// Used as fallback when chapter config is null
class MiniTestConfig {
  /// Default total questions for mini test
  static const int defaultTotalQuestions = 6;
  
  /// Default time limit in minutes
  static const int defaultTimeLimitMinutes = 10;
  
  /// Default time limit in seconds
  static const int defaultTimeLimitSec = 600;
  
  /// Default passing score (percentage)
  static const int defaultPassingScore = 70;
  
  /// Minimum practice questions required to unlock mini test
  static const int defaultRequiredPracticeCount = 10;
}

