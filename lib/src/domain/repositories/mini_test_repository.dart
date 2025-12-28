import '../../core/base/response_object.dart';
import '../entities/mini_test_result_entity.dart';
import '../entities/mini_test_session_entity.dart';

abstract class MiniTestRepository {
  Future<ResponseObject<MiniTestSessionEntity>> startTest({
    required String chapterId,
  });

  Future<ResponseObject<MiniTestSessionEntity>> getTestSession(String sessionId);

  Future<ResponseObject<MiniTestSessionEntity>> submitAnswer({
    required String sessionId,
    required int questionIndex,
    required String answer,
  });

  Future<ResponseObject<MiniTestResultEntity>> submitTest(String sessionId);

  Future<ResponseObject<bool>> checkUnlock(String chapterId);
}

