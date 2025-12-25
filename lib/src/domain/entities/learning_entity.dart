class RecommendedSkillEntity {
  final String? skillId;
  final String? skillCode;
  final String? skillName;
  final int? difficultyLevel;
  final String? activityType; // "review", "practice", "mini_test"
  final String? recommendationReason;
  final List<String> prerequisiteSkills;

  RecommendedSkillEntity({
    this.skillId,
    this.skillCode,
    this.skillName,
    this.difficultyLevel,
    this.activityType,
    this.recommendationReason,
    required this.prerequisiteSkills,
  });
}

class ProgressSummaryEntity {
  final int totalSkills;
  final int masteredSkills; // mastery >= 90
  final int needsPracticeSkills; // mastery < 70
  final int weakSkills; // mastery < 40
  final double overallMastery; // Average mastery

  ProgressSummaryEntity({
    required this.totalSkills,
    required this.masteredSkills,
    required this.needsPracticeSkills,
    required this.weakSkills,
    required this.overallMastery,
  });
}

class LearningPlanEntity {
  final RecommendedSkillEntity? recommendedSkill;
  final ProgressSummaryEntity progressSummary;

  LearningPlanEntity({
    this.recommendedSkill,
    required this.progressSummary,
  });
}

