import '../../core/base/response_object.dart';
import '../../domain/entities/mini_test_result_entity.dart';
import '../../domain/entities/mini_test_session_entity.dart';
import '../../domain/repositories/mini_test_repository.dart';
import '../models/mini_test_result_model.dart';
import '../models/mini_test_session_model.dart';
import '../services/network/services/mini_test_service.dart';

final class MiniTestRepositoryImpl extends MiniTestRepository {
  MiniTestRepositoryImpl({
    required this.miniTestService,
  });

  final MiniTestService miniTestService;

  @override
  Future<ResponseObject<MiniTestSessionEntity>> startTest({
    required String skillId,
  }) async {
    try {
      final response = await miniTestService.startMiniTest({
        'skillId': skillId,
      });

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
          errorDetail: responseData.errorDetail ?? 'Failed to start mini test',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = MiniTestSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to start mini test: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<MiniTestSessionEntity>> getTestSession(String sessionId) async {
    try {
      final response = await miniTestService.getTestSession(sessionId);

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
          errorDetail: responseData.errorDetail ?? 'Failed to get test session',
        );
      }

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = MiniTestSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get test session: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<MiniTestSessionEntity>> submitAnswer({
    required String sessionId,
    required int questionIndex,
    required String answer,
  }) async {
    try {
      final response = await miniTestService.submitAnswer(
        sessionId,
        {
          'questionIndex': questionIndex,
          'answer': answer,
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

      final sessionData = responseData.data;
      if (sessionData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final session = MiniTestSessionModel.fromJson(sessionData);
      return ResponseObject.success(session);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to submit answer: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<MiniTestResultEntity>> submitTest(String sessionId) async {
    try {
      final response = await miniTestService.submitTest(sessionId);

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
          errorDetail: responseData.errorDetail ?? 'Failed to submit test',
        );
      }

      final resultData = responseData.data;
      if (resultData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final result = MiniTestResultModel.fromJson(resultData);
      return ResponseObject.success(result);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to submit test: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<bool>> checkUnlock(String skillId) async {
    try {
      final response = await miniTestService.checkUnlock(skillId);

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

      final responseData = ResponseObject<bool>.fromJson(
        responseMap,
        (data) => data is bool ? data : false,
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to check unlock',
        );
      }

      return ResponseObject.success(responseData.data ?? false);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to check unlock: ${e.toString()}',
      );
    }
  }
}

