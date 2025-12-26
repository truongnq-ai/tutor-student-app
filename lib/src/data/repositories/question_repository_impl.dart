import '../../core/base/response_object.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/repositories/question_repository.dart';
import '../models/question_model.dart';
import '../services/network/services/practice_service.dart';
import '../services/network/services/practice_session_service.dart';

final class QuestionRepositoryImpl extends QuestionRepository {
  QuestionRepositoryImpl({
    required this.practiceService,
    required this.practiceSessionService,
  });

  final PracticeService practiceService;
  final PracticeSessionService practiceSessionService;

  @override
  Future<ResponseObject<QuestionEntity>> getQuestionById(String questionId) async {
    try {
      final response = await practiceService.getPracticeQuestionDetail(questionId);

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
          errorDetail: responseData.errorDetail ?? 'Failed to get question',
        );
      }

      final questionData = responseData.data;
      if (questionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final question = QuestionModel.fromJson(questionData);
      return ResponseObject.success(question);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get question: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<List<QuestionEntity>>> getQuestionsBySession(String sessionId) async {
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
  Future<ResponseObject<QuestionEntity>> submitQuestionAnswer({
    required String questionId,
    required String answer,
    int? durationSec,
  }) async {
    try {
      final response = await practiceService.submitPracticeQuestion(
        questionId,
        {
          'answer': answer,
          if (durationSec != null) 'durationSec': durationSec,
        },
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
          errorDetail: responseData.errorDetail ?? 'Failed to submit answer',
        );
      }

      final questionData = responseData.data;
      if (questionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final question = QuestionModel.fromJson(questionData);
      return ResponseObject.success(question);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to submit answer: ${e.toString()}',
      );
    }
  }
}

