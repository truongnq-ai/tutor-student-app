import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/mini_test_session_entity.dart';

part 'mini_test_session_model.mapper.dart';

@MappableClass()
class MiniTestSessionModel extends MiniTestSessionEntity
    with MiniTestSessionModelMappable {
  const MiniTestSessionModel({
    required super.sessionId,
    super.chapterId,
    super.chapterName,
    super.skillId,
    super.skillCode,
    super.skillName,
    required super.status,
    required super.startedAt,
    required super.timeLimitSec,
    required super.timeRemainingSec,
    required super.totalQuestions,
    required super.currentQuestionIndex,
    required super.answers,
  });

  static const fromJson = MiniTestSessionModelMapper.fromJson;
}

