import '../../domain/entities/practice_entity.dart';

class PracticeHistoryModel extends PracticeHistoryEntity {
  PracticeHistoryModel({
    required super.id,
    required super.studentId,
    super.skillId,
    super.skillCode,
    super.skillName,
    super.questionId,
    super.questionProblemText,
    required super.isCorrect,
    super.durationSec,
    super.masteryLevel,
    required super.createdAt,
  });

  factory PracticeHistoryModel.fromJson(Map<String, dynamic> json) {
    return PracticeHistoryModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      skillId: json['skillId'] as String?,
      skillCode: json['skillCode'] as String?,
      skillName: json['skillName'] as String?,
      questionId: json['questionId'] as String?,
      questionProblemText: json['questionProblemText'] as String?,
      isCorrect: json['isCorrect'] as bool? ?? false,
      durationSec: json['durationSec'] as int?,
      masteryLevel: json['masteryLevel'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class PracticeResponseModel extends PracticeResponseEntity {
  PracticeResponseModel({
    required super.id,
    required super.studentId,
    super.trialId,
    required super.skillId,
    super.questionId,
    required super.isCorrect,
    required super.durationSec,
    required super.createdAt,
  });

  factory PracticeResponseModel.fromJson(Map<String, dynamic> json) {
    return PracticeResponseModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      trialId: json['trialId'] as String?,
      skillId: json['skillId'] as String,
      questionId: json['questionId'] as String?,
      isCorrect: json['isCorrect'] as bool? ?? false,
      durationSec: json['durationSec'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

