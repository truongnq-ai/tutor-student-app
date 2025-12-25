import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/session_info_entity.dart';

part 'session_info_model.mapper.dart';

@MappableClass()
class SessionInfoModel extends SessionInfoEntity with SessionInfoModelMappable {
  const SessionInfoModel({
    required super.sessionId,
    required super.skillId,
    super.skillName,
    super.skillCode,
    required super.totalQuestions,
    required super.completedQuestions,
    required super.currentQuestionIndex,
    super.currentMastery,
    super.startedAt,
    super.lastActivityAt,
  });

  static const fromJson = SessionInfoModelMapper.fromJson;
}

