import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/skill_detail_entity.dart';

part 'skill_detail_model.mapper.dart';

@MappableClass()
class SkillDetailModel extends SkillDetailEntity with SkillDetailModelMappable {
  const SkillDetailModel({
    required super.skillId,
    required super.skillCode,
    required super.skillName,
    super.chapterId,
    super.chapterName,
    required super.grade,
    required super.masteryLevel,
    required super.status,
    required super.totalPractices,
    required super.masteryTimeline,
    required super.recentPractices,
    required super.prerequisites,
    required super.canTakeMiniTest,
  });

  static const fromJson = SkillDetailModelMapper.fromJson;
}

@MappableClass()
class MasteryTimelineItemModel extends MasteryTimelineItem
    with MasteryTimelineItemModelMappable {
  const MasteryTimelineItemModel({
    required super.date,
    required super.masteryLevel,
  });

  static const fromJson = MasteryTimelineItemModelMapper.fromJson;
}

@MappableClass()
class RecentPracticeItemModel extends RecentPracticeItem
    with RecentPracticeItemModelMappable {
  const RecentPracticeItemModel({
    required super.practiceId,
    required super.questionPreview,
    required super.isCorrect,
    required super.practicedAt,
  });

  static const fromJson = RecentPracticeItemModelMapper.fromJson;
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

