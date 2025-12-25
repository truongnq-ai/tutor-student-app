import '../../core/base/response_object.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/repositories/question_repository.dart';
import '../models/question_model.dart';
import '../services/network/services/practice_service.dart';

final class QuestionRepositoryImpl extends QuestionRepository {
  QuestionRepositoryImpl({
    required this.practiceService,
  });

  final PracticeService practiceService;

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
      // This would need a new endpoint or use existing practiceQuestions endpoint
      // For now, return error as this endpoint might not exist yet
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Not implemented yet',
      );
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get questions: ${e.toString()}',
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

