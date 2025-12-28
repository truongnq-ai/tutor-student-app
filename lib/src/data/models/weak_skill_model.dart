import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/weak_skill_entity.dart';

part 'weak_skill_model.mapper.dart';

@MappableClass()
class WeakSkillModel extends WeakSkillEntity with WeakSkillModelMappable {
  const WeakSkillModel({
    required super.skillId,
    required super.skillCode,
    required super.skillName,
    required super.chapter,
    super.description,
    required super.masteryLevel,
    required super.status,
    required super.questionCount,
    required super.estimatedTimeMinutes,
    required super.isPriority,
  });

  static const fromJson = WeakSkillModelMapper.fromJson;
}

