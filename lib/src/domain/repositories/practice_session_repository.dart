import '../../core/base/response_object.dart';
import '../entities/practice_session_entity.dart';
import '../entities/question_entity.dart';

abstract class PracticeSessionRepository {
  Future<ResponseObject<PracticeSessionEntity>> createSession({
    required String skillId,
    required int totalQuestions,
    String? trialId,
    String? anonymousId,
  });

  Future<ResponseObject<PracticeSessionEntity>> getSession(String sessionId);

  Future<ResponseObject<List<QuestionEntity>>> getQuestionsInSession(String sessionId);

  Future<ResponseObject<PracticeSessionEntity>> pauseSession(String sessionId);

  Future<ResponseObject<PracticeSessionEntity>> resumeSession(String sessionId);

  Future<ResponseObject<PracticeSessionEntity>> completeSession(String sessionId);

  Future<ResponseObject<PracticeSessionEntity>> cancelSession(String sessionId);

  Future<ResponseObject<List<PracticeSessionEntity>>> getResumableSessions({
    String? trialId,
    String? anonymousId,
  });
}

