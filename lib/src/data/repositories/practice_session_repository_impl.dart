import '../../core/base/response_object.dart';
import '../../domain/entities/practice_session_entity.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/repositories/practice_session_repository.dart';
import '../models/practice_session_model.dart';
import '../models/question_model.dart';
import '../services/network/services/practice_session_service.dart';

final class PracticeSessionRepositoryImpl extends PracticeSessionRepository {
  PracticeSessionRepositoryImpl({
    required this.practiceSessionService,
  });

  final PracticeSessionService practiceSessionService;

  @override
  Future<ResponseObject<PracticeSessionEntity>> createSession({
    required String skillId,
    required int totalQuestions,
    String? trialId,
    String? anonymousId,
  }) async {
    try {
      final response = await practiceSessionService.createSession(
        {
          'skillId': skillId,
          'totalQuestions': totalQuestions,
        },
        trialId,
        anonymousId,
      );

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to create practice session',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = PracticeSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to create practice session: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<PracticeSessionEntity>> getSession(String sessionId) async {
    try {
      final response = await practiceSessionService.getSession(sessionId);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get practice session',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = PracticeSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get practice session: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<List<QuestionEntity>>> getQuestionsInSession(String sessionId) async {
    try {
      final response = await practiceSessionService.getQuestionsInSession(sessionId);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<dynamic>.fromJson(
        responseMap,
        (data) => data,
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get questions in session',
        );
      }

      final questionsData = responseData.data;
      if (questionsData == null) {
        return ResponseObject.success([]);
      }

      if (questionsData is! List) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format: expected list',
        );
      }

      final questions = (questionsData as List<dynamic>)
          .map((item) {
            if (item is Map<String, dynamic>) {
              return QuestionModel.fromJson(item);
            }
            return null;
          })
          .whereType<QuestionEntity>()
          .toList();

      return ResponseObject.success(questions);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get questions in session: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<PracticeSessionEntity>> pauseSession(String sessionId) async {
    try {
      final response = await practiceSessionService.pauseSession(sessionId);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to pause practice session',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = PracticeSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to pause practice session: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<PracticeSessionEntity>> resumeSession(String sessionId) async {
    try {
      final response = await practiceSessionService.resumeSession(sessionId);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to resume practice session',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = PracticeSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to resume practice session: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<PracticeSessionEntity>> completeSession(String sessionId) async {
    try {
      final response = await practiceSessionService.completeSession(sessionId);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to complete practice session',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = PracticeSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to complete practice session: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<PracticeSessionEntity>> cancelSession(String sessionId) async {
    try {
      final response = await practiceSessionService.cancelSession(sessionId);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to cancel practice session',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = PracticeSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to cancel practice session: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<List<PracticeSessionEntity>>> getResumableSessions({
    String? trialId,
    String? anonymousId,
  }) async {
    try {
      final response = await practiceSessionService.getResumableSessions(
        trialId,
        anonymousId,
      );

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<List<dynamic>>.fromJson(
        responseMap,
        (data) => data is List ? data : <dynamic>[],
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get resumable sessions',
        );
      }

      final sessionsData = responseData.data;
      if (sessionsData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final sessions = sessionsData
          .map((item) => PracticeSessionModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return ResponseObject.success(sessions);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get resumable sessions: ${e.toString()}',
      );
    }
  }
}

