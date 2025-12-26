import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/practice_session_entity.dart';

part 'practice_session_model.mapper.dart';

@MappableClass()
class PracticeSessionModel extends PracticeSessionEntity
    with PracticeSessionModelMappable {
  const PracticeSessionModel({
    required super.sessionId,
    required super.skillId,
    required super.skillCode,
    required super.skillName,
    required super.status,
    required super.startedAt,
    super.pausedAt,
    super.completedAt,
    required super.totalQuestions,
    required super.currentQuestionIndex,
    required super.completedQuestions,
  });

  static const fromJson = PracticeSessionModelMapper.fromJson;
}

