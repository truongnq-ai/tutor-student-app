class QuestionEntity {
  final String id;
  final String? skillId;
  final String? skillName;
  final String? problemText;
  final String? problemLatex;
  final String? problemImageUrl;
  final List<String>? answerOptions; // For multiple choice
  final String? finalAnswer;
  final List<String>? hints;
  final int? difficultyLevel;
  final String? sessionId;
  final int? questionNumber; // Position in session (1-based)
  final int? totalQuestions; // Total questions in session

  QuestionEntity({
    required this.id,
    this.skillId,
    this.skillName,
    this.problemText,
    this.problemLatex,
    this.problemImageUrl,
    this.answerOptions,
    this.finalAnswer,
    this.hints,
    this.difficultyLevel,
    this.sessionId,
    this.questionNumber,
    this.totalQuestions,
  });
}

