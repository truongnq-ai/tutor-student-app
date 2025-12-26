import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/recommendation_entity.dart';

part 'recommendation_model.mapper.dart';

@MappableClass()
class RecommendationModel extends RecommendationEntity
    with RecommendationModelMappable {
  const RecommendationModel({
    required super.summary,
    required super.recommendations,
    required super.weakSkills,
    required super.prerequisites,
    required super.nextSteps,
  });

  static const fromJson = RecommendationModelMapper.fromJson;
}

@MappableClass()
class RecommendationItemModel extends RecommendationItem
    with RecommendationItemModelMappable {
  const RecommendationItemModel({
    required super.icon,
    required super.title,
    required super.description,
    required super.action,
    super.skillId,
    required super.priority,
  });

  static const fromJson = RecommendationItemModelMapper.fromJson;
}

@MappableClass()
class PrerequisiteSkillItemModel extends PrerequisiteSkillItem
    with PrerequisiteSkillItemModelMappable {
  const PrerequisiteSkillItemModel({
    required super.skillId,
    required super.skillCode,
    required super.skillName,
    required super.masteryLevel,
  });

  static const fromJson = PrerequisiteSkillItemModelMapper.fromJson;
}

