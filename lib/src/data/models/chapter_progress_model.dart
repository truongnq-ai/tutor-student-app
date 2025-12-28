import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/chapter_progress_entity.dart';

part 'chapter_progress_model.mapper.dart';

@MappableClass()
class ChapterProgressModel extends ChapterProgressEntity
    with ChapterProgressModelMappable {
  const ChapterProgressModel({
    required super.chapterId,
    required super.chapterName,
    required super.chapterCode,
    required super.averageMastery,
    required super.completionPercentage,
    required super.totalSkills,
    required super.masteredSkills,
    required super.status,
    super.miniTestTotalQuestions,
    super.miniTestTimeLimitSec,
    super.miniTestPassingScore,
    super.miniTestRequiredPracticeCount,
  });

  static const fromJson = ChapterProgressModelMapper.fromJson;
}

