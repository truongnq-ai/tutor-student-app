import '../../domain/entities/learning_entity.dart';

class RecommendedSkillModel extends RecommendedSkillEntity {
  RecommendedSkillModel({
    super.skillId,
    super.skillCode,
    super.skillName,
    super.difficultyLevel,
    super.activityType,
    super.recommendationReason,
    required super.prerequisiteSkills,
  });

  factory RecommendedSkillModel.fromJson(Map<String, dynamic> json) {
    return RecommendedSkillModel(
      skillId: json['skillId'] as String?,
      skillCode: json['skillCode'] as String?,
      skillName: json['skillName'] as String?,
      difficultyLevel: json['difficultyLevel'] as int?,
      activityType: json['activityType'] as String?,
      recommendationReason: json['recommendationReason'] as String?,
      prerequisiteSkills: (json['prerequisiteSkills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class ProgressSummaryModel extends ProgressSummaryEntity {
  ProgressSummaryModel({
    required super.totalSkills,
    required super.masteredSkills,
    required super.needsPracticeSkills,
    required super.weakSkills,
    required super.overallMastery,
  });

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProgressSummaryModel(
      totalSkills: json['totalSkills'] as int? ?? 0,
      masteredSkills: json['masteredSkills'] as int? ?? 0,
      needsPracticeSkills: json['needsPracticeSkills'] as int? ?? 0,
      weakSkills: json['weakSkills'] as int? ?? 0,
      overallMastery: (json['overallMastery'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class LearningPlanModel extends LearningPlanEntity {
  LearningPlanModel({
    super.recommendedSkill,
    required super.progressSummary,
  });

  factory LearningPlanModel.fromJson(Map<String, dynamic> json) {
    return LearningPlanModel(
      recommendedSkill: json['recommendedSkill'] != null
          ? RecommendedSkillModel.fromJson(
              json['recommendedSkill'] as Map<String, dynamic>)
          : null,
      progressSummary: ProgressSummaryModel.fromJson(
          json['progressSummary'] as Map<String, dynamic>),
    );
  }
}

