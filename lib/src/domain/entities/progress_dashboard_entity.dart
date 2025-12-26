import 'package:equatable/equatable.dart';

import 'weak_skill_entity.dart';

class ProgressDashboardEntity extends Equatable {
  final int streakDays;
  final int totalPractices;
  final int correctCount;
  final int totalTimeSec;
  final double accuracyRate;
  final List<SkillProgressItem> skills;
  final List<WeakSkillEntity> weakSkills;
  final List<ProgressDayData> progressLast7Days;

  const ProgressDashboardEntity({
    required this.streakDays,
    required this.totalPractices,
    required this.correctCount,
    required this.totalTimeSec,
    required this.accuracyRate,
    required this.skills,
    required this.weakSkills,
    required this.progressLast7Days,
  });

  @override
  List<Object> get props => [
        streakDays,
        totalPractices,
        correctCount,
        totalTimeSec,
        accuracyRate,
        skills,
        weakSkills,
        progressLast7Days,
      ];
}

class SkillProgressItem extends Equatable {
  final String skillId;
  final String skillCode;
  final String skillName;
  final int masteryLevel;
  final String status; // "weak", "improving", "mastered"

  const SkillProgressItem({
    required this.skillId,
    required this.skillCode,
    required this.skillName,
    required this.masteryLevel,
    required this.status,
  });

  @override
  List<Object> get props => [skillId, skillCode, skillName, masteryLevel, status];
}

class ProgressDayData extends Equatable {
  final String date; // Format: "YYYY-MM-DD"
  final int practicesCount;
  final int correctCount;
  final int averageMastery;

  const ProgressDayData({
    required this.date,
    required this.practicesCount,
    required this.correctCount,
    required this.averageMastery,
  });

  @override
  List<Object> get props => [date, practicesCount, correctCount, averageMastery];
}

