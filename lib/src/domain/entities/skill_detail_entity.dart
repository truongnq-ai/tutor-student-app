import 'package:equatable/equatable.dart';

class SkillDetailEntity extends Equatable {
  final String skillId;
  final String skillCode;
  final String skillName;
  final String chapter;
  final int grade;
  final int masteryLevel;
  final String status; // "weak", "improving", "mastered"
  final int totalPractices;
  final List<MasteryTimelineItem> masteryTimeline;
  final List<RecentPracticeItem> recentPractices;
  final List<PrerequisiteSkillItem> prerequisites;
  final bool canTakeMiniTest;

  const SkillDetailEntity({
    required this.skillId,
    required this.skillCode,
    required this.skillName,
    required this.chapter,
    required this.grade,
    required this.masteryLevel,
    required this.status,
    required this.totalPractices,
    required this.masteryTimeline,
    required this.recentPractices,
    required this.prerequisites,
    required this.canTakeMiniTest,
  });

  @override
  List<Object> get props => [
        skillId,
        skillCode,
        skillName,
        chapter,
        grade,
        masteryLevel,
        status,
        totalPractices,
        masteryTimeline,
        recentPractices,
        prerequisites,
        canTakeMiniTest,
      ];
}

class MasteryTimelineItem extends Equatable {
  final String date; // Format: "YYYY-MM-DD"
  final int masteryLevel;

  const MasteryTimelineItem({
    required this.date,
    required this.masteryLevel,
  });

  @override
  List<Object> get props => [date, masteryLevel];
}

class RecentPracticeItem extends Equatable {
  final String practiceId;
  final String questionPreview;
  final bool isCorrect;
  final DateTime practicedAt;

  const RecentPracticeItem({
    required this.practiceId,
    required this.questionPreview,
    required this.isCorrect,
    required this.practicedAt,
  });

  @override
  List<Object> get props => [practiceId, questionPreview, isCorrect, practicedAt];
}

class PrerequisiteSkillItem extends Equatable {
  final String skillId;
  final String skillCode;
  final String skillName;
  final int masteryLevel;

  const PrerequisiteSkillItem({
    required this.skillId,
    required this.skillCode,
    required this.skillName,
    required this.masteryLevel,
  });

  @override
  List<Object> get props => [skillId, skillCode, skillName, masteryLevel];
}

