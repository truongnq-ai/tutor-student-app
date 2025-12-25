class PracticeHistoryEntity {
  final String id;
  final String studentId;
  final String? skillId;
  final String? skillCode;
  final String? skillName;
  final String? questionId;
  final String? questionProblemText;
  final bool isCorrect;
  final int? durationSec;
  final int? masteryLevel;
  final DateTime createdAt;

  PracticeHistoryEntity({
    required this.id,
    required this.studentId,
    this.skillId,
    this.skillCode,
    this.skillName,
    this.questionId,
    this.questionProblemText,
    required this.isCorrect,
    this.durationSec,
    this.masteryLevel,
    required this.createdAt,
  });
}

class PracticeResponseEntity {
  final String id;
  final String studentId;
  final String? trialId;
  final String skillId;
  final String? questionId;
  final bool isCorrect;
  final int durationSec;
  final DateTime createdAt;

  PracticeResponseEntity({
    required this.id,
    required this.studentId,
    this.trialId,
    required this.skillId,
    this.questionId,
    required this.isCorrect,
    required this.durationSec,
    required this.createdAt,
  });
}

