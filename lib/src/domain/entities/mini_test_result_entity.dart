import 'package:equatable/equatable.dart';

class MiniTestResultEntity extends Equatable {
  final String resultId;
  final String? chapterId;
  final String? chapterName;
  final String? skillId;  // Kept for backward compatibility
  final String? skillCode;
  final String? skillName;
  final int score; // 0-100
  final bool passed; // score >= 70
  final int totalQuestions;
  final int correctAnswers;
  final int timeTakenSec;
  final int previousMasteryLevel;
  final int newMasteryLevel;
  final List<SkillBreakdownItem> skillBreakdown;  // Skill-level analysis
  final String recommendation;
  final DateTime completedAt;

  const MiniTestResultEntity({
    required this.resultId,
    this.chapterId,
    this.chapterName,
    this.skillId,
    this.skillCode,
    this.skillName,
    required this.score,
    required this.passed,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTakenSec,
    required this.previousMasteryLevel,
    required this.newMasteryLevel,
    required this.skillBreakdown,
    required this.recommendation,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [
        resultId,
        chapterId,
        chapterName,
        skillId,
        skillCode,
        skillName,
        score,
        passed,
        totalQuestions,
        correctAnswers,
        timeTakenSec,
        previousMasteryLevel,
        newMasteryLevel,
        skillBreakdown,
        recommendation,
        completedAt,
      ];
}

class SkillBreakdownItem extends Equatable {
  final String skillId;
  final String skillCode;
  final String skillName;
  final int correctCount;
  final int totalCount;

  const SkillBreakdownItem({
    required this.skillId,
    required this.skillCode,
    required this.skillName,
    required this.correctCount,
    required this.totalCount,
  });

  @override
  List<Object> get props => [skillId, skillCode, skillName, correctCount, totalCount];
}

