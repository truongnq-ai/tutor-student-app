class RecommendedSkillEntity {
  final String? skillId;
  final String? skillCode;
  final String? skillName;
  final List<String> prerequisiteSkills;

  RecommendedSkillEntity({
    this.skillId,
    this.skillCode,
    this.skillName,
    required this.prerequisiteSkills,
  });
}

class RecommendedChapterEntity {
  final String? chapterId;
  final String? chapterName;
  final String? chapterCode;
  final int? difficultyLevel;
  final String? activityType; // "review", "practice", "mini_test"
  final String? recommendationReason;
  final List<RecommendedSkillEntity> skills;  // Skills within chapter to focus on

  RecommendedChapterEntity({
    this.chapterId,
    this.chapterName,
    this.chapterCode,
    this.difficultyLevel,
    this.activityType,
    this.recommendationReason,
    required this.skills,
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
  final RecommendedChapterEntity? recommendedChapter;
  final ProgressSummaryEntity progressSummary;

  LearningPlanEntity({
    this.recommendedChapter,
    required this.progressSummary,
  });
}

