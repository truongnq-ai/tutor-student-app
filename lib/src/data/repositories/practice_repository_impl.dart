import '../../core/base/response_object.dart';
import '../../domain/entities/practice_entity.dart';
import '../../domain/entities/session_info_entity.dart';
import '../../domain/repositories/practice_repository.dart';
import '../models/practice_model.dart';
import '../models/session_info_model.dart';
import '../services/network/services/practice_service.dart';

final class PracticeRepositoryImpl extends PracticeRepository {
  PracticeRepositoryImpl({
    required this.practiceService,
  });

  final PracticeService practiceService;

  @override
  Future<ResponseObject<PracticeResponseEntity>> submitPractice({
    required String skillId,
    required String answer,
    int? durationSec,
    String? questionId,
    String? sessionId,
    String? sessionType,
  }) async {
    try {
      if (questionId == null) {
        return ResponseObject.error(
          errorCode: '2007',
          errorDetail: 'questionId is required',
        );
      }

      final response = await practiceService.submitPracticeQuestion(
        questionId,
        {
          'answer': answer,
          if (durationSec != null) 'durationSec': durationSec,
          if (sessionId != null) 'sessionId': sessionId,
          if (sessionType != null) 'sessionType': sessionType,
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
          errorDetail: responseData.errorDetail ?? 'Failed to submit practice',
        );
      }

      final questionData = responseData.data;
      if (questionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      // The new endpoint returns QuestionResponse, which may contain latestPractice
      // Check if latestPractice is available in the response
      final latestPracticeData = questionData['latestPractice'] as Map<String, dynamic>?;
      if (latestPracticeData != null) {
        // Use the practice data from the response
        final practice = PracticeResponseModel.fromJson(latestPracticeData);
        return ResponseObject.success(practice);
      }

      // Fallback: Create minimal PracticeResponseEntity from available data
      // Calculate isCorrect by comparing answer with question's finalAnswer
      final questionFinalAnswer = questionData['finalAnswer'] as String?;
      final isCorrect = questionFinalAnswer != null &&
          questionFinalAnswer.trim().toLowerCase() == answer.trim().toLowerCase();

      // Create minimal PracticeResponseEntity
      // Note: We don't have practice ID from the new endpoint, so we use questionId as a placeholder
      // The actual practice record is created on the backend
      final practice = PracticeResponseModel(
        id: questionId, // Temporary: use questionId as practice ID placeholder
        studentId: questionData['assignedToStudentId'] as String? ?? '', // From question response
        trialId: null,
        skillId: skillId,
        questionId: questionId,
        isCorrect: isCorrect,
        durationSec: durationSec ?? 0,
        createdAt: DateTime.now(),
      );
      return ResponseObject.success(practice);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to submit practice: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<Map<String, dynamic>>> getPracticeHistory({
    int page = 0,
    int pageSize = 20,
    String? skillId,
  }) async {
    try {
      final response = await practiceService.getPracticeHistory(
        page,
        pageSize,
        skillId,
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
          errorDetail: responseData.errorDetail ?? 'Failed to get practice history',
        );
      }

      return ResponseObject.success(responseData.data ?? <String, dynamic>{});
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get practice history: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<SessionInfoEntity>> getSessionInfo(String sessionId) async {
    try {
      final response = await practiceService.getSessionInfo(sessionId);

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
          errorDetail: responseData.errorDetail ?? 'Failed to get session info',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final sessionInfo = SessionInfoModel.fromJson(sessionData);
      return ResponseObject.success(sessionInfo);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get session info: ${e.toString()}',
      );
    }
  }
}

