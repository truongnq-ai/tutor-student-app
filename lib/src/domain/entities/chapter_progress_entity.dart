import 'package:equatable/equatable.dart';

class ChapterProgressEntity extends Equatable {
  final String chapterId;
  final String chapterName;
  final String chapterCode;
  final double averageMastery;  // Average mastery across all skills in chapter
  final double completionPercentage;  // Percentage of skills with mastery >= 70
  final int totalSkills;
  final int masteredSkills;  // Skills with mastery >= 70
  final String status;  // "new", "in_progress", "near_complete", "mastered"
  // Mini Test Configuration (nullable, uses defaults if null)
  final int? miniTestTotalQuestions;
  final int? miniTestTimeLimitSec;
  final int? miniTestPassingScore;
  final int? miniTestRequiredPracticeCount;

  const ChapterProgressEntity({
    required this.chapterId,
    required this.chapterName,
    required this.chapterCode,
    required this.averageMastery,
    required this.completionPercentage,
    required this.totalSkills,
    required this.masteredSkills,
    required this.status,
    this.miniTestTotalQuestions,
    this.miniTestTimeLimitSec,
    this.miniTestPassingScore,
    this.miniTestRequiredPracticeCount,
  });

  @override
  List<Object?> get props => [
        chapterId,
        chapterName,
        chapterCode,
        averageMastery,
        completionPercentage,
        totalSkills,
        masteredSkills,
        status,
        miniTestTotalQuestions,
        miniTestTimeLimitSec,
        miniTestPassingScore,
        miniTestRequiredPracticeCount,
      ];
}

