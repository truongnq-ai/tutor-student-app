import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/progress_dashboard_entity.dart';

part 'progress_dashboard_model.mapper.dart';

@MappableClass()
class ProgressDashboardModel extends ProgressDashboardEntity
    with ProgressDashboardModelMappable {
  const ProgressDashboardModel({
    required super.streakDays,
    required super.totalPractices,
    required super.correctCount,
    required super.totalTimeSec,
    required super.accuracyRate,
    required super.skills,
    required super.weakSkills,
    required super.progressLast7Days,
  });

  static const fromJson = ProgressDashboardModelMapper.fromJson;
}

@MappableClass()
class SkillProgressItemModel extends SkillProgressItem
    with SkillProgressItemModelMappable {
  const SkillProgressItemModel({
    required super.skillId,
    required super.skillCode,
    required super.skillName,
    required super.masteryLevel,
    required super.status,
  });

  static const fromJson = SkillProgressItemModelMapper.fromJson;
}

@MappableClass()
class ProgressDayDataModel extends ProgressDayData
    with ProgressDayDataModelMappable {
  const ProgressDayDataModel({
    required super.date,
    required super.practicesCount,
    required super.correctCount,
    required super.averageMastery,
  });

  static const fromJson = ProgressDayDataModelMapper.fromJson;
}

