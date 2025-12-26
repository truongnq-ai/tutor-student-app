import 'package:equatable/equatable.dart';

import 'weak_skill_entity.dart';

class RecommendationEntity extends Equatable {
  final String summary;
  final List<RecommendationItem> recommendations;
  final List<WeakSkillEntity> weakSkills;
  final List<PrerequisiteSkillItem> prerequisites;
  final List<String> nextSteps;

  const RecommendationEntity({
    required this.summary,
    required this.recommendations,
    required this.weakSkills,
    required this.prerequisites,
    required this.nextSteps,
  });

  @override
  List<Object> get props => [
        summary,
        recommendations,
        weakSkills,
        prerequisites,
        nextSteps,
      ];
}

class RecommendationItem extends Equatable {
  final String icon; // "💡", "🎯", "⚠️"
  final String title;
  final String description;
  final String action; // "Luyện tập ngay", "Học skill này trước"
  final String? skillId; // Optional, for navigation
  final String priority; // "high", "medium", "low"

  const RecommendationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
    this.skillId,
    required this.priority,
  });

  @override
  List<Object?> get props => [
        icon,
        title,
        description,
        action,
        skillId,
        priority,
      ];
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

