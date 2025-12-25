import '../../domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.id,
    super.skillId,
    super.skillName,
    super.problemText,
    super.problemLatex,
    super.problemImageUrl,
    super.answerOptions,
    super.finalAnswer,
    super.hints,
    super.difficultyLevel,
    super.sessionId,
    super.questionNumber,
    super.totalQuestions,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      skillId: json['skillId'] as String?,
      skillName: () {
        final skill = json['skill'];
        if (skill != null && skill is Map<String, dynamic>) {
          return skill['name'] as String?;
        }
        return null;
      }(),
      problemText: json['problemText'] as String?,
      problemLatex: json['problemLatex'] as String?,
      problemImageUrl: json['problemImageUrl'] as String?,
      answerOptions: json['answerOptions'] != null
          ? (json['answerOptions'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : null,
      finalAnswer: json['finalAnswer'] as String?,
      hints: json['hints'] != null
          ? (json['hints'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
      difficultyLevel: json['difficultyLevel'] as int?,
      sessionId: json['sessionId'] as String?,
    );
  }
}

