import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/mini_test_result_entity.dart';

part 'mini_test_result_model.mapper.dart';

@MappableClass()
class MiniTestResultModel extends MiniTestResultEntity
    with MiniTestResultModelMappable {
  const MiniTestResultModel({
    required super.resultId,
    super.chapterId,
    super.chapterName,
    super.skillId,
    super.skillCode,
    super.skillName,
    required super.score,
    required super.passed,
    required super.totalQuestions,
    required super.correctAnswers,
    required super.timeTakenSec,
    required super.previousMasteryLevel,
    required super.newMasteryLevel,
    required super.skillBreakdown,
    required super.recommendation,
    required super.completedAt,
  });

  static const fromJson = MiniTestResultModelMapper.fromJson;
}

@MappableClass()
class SkillBreakdownItemModel extends SkillBreakdownItem
    with SkillBreakdownItemModelMappable {
  const SkillBreakdownItemModel({
    required super.skillId,
    required super.skillCode,
    required super.skillName,
    required super.correctCount,
    required super.totalCount,
  });

  static const fromJson = SkillBreakdownItemModelMapper.fromJson;
}

