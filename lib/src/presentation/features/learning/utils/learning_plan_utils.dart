/// Utility functions for Learning Plan feature
class LearningPlanUtils {
  /// Calculate total questions for Learning Plan session based on difficulty level.
  ///
  /// Mapping:
  /// - Difficulty 1-2 (Easy-Medium): 10 questions
  /// - Difficulty 3-4 (Fair-Hard): 8 questions
  /// - Difficulty 5 (Very Hard): 5 questions
  /// - Default/Unknown: 10 questions
  ///
  /// Returns the calculated total questions count.
  static int calculateTotalQuestionsForLearningPlan(int? difficultyLevel) {
    if (difficultyLevel == null) return 10;
    if (difficultyLevel <= 2) return 10;
    if (difficultyLevel <= 4) return 8;
    return 5; // difficultyLevel == 5
  }
}

