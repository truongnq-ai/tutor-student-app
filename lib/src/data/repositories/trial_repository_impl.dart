import '../../core/base/response_object.dart';
import '../../core/constants/error_codes.dart';
import '../../domain/entities/student_check_entity.dart';
import '../../domain/entities/trial_entity.dart';
import '../../domain/repositories/trial_repository.dart';
import '../models/student_check_model.dart';
import '../models/trial_model.dart';
import '../services/cache/cache_service.dart';
import '../services/network/services/student_service.dart';

final class TrialRepositoryImpl extends TrialRepository {
  TrialRepositoryImpl({
    required this.studentService,
    required this.cacheService,
  });

  final StudentService studentService;
  final CacheService cacheService;

  @override
  Future<ResponseObject<TrialEntity>> getTrialStatus() async {
    try {
      // Authentication is handled by TokenManager (JWT token in headers)
      final response = await studentService.getTrialStatus();

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Invalid response format',
        );
      }

      // Ensure responseJson is a Map
      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      // Parse ResponseObject from JSON
      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        // Handle specific error codes
        final errorCode = responseData.errorCode ?? ErrorCodes.internalError;
        if (errorCode == ErrorCodes.trialNotFound) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Trial not found',
          );
        }
        if (errorCode == ErrorCodes.trialExpired) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Trial has expired',
          );
        }
        return ResponseObject.error(
          errorCode: errorCode,
          errorDetail: responseData.errorDetail ?? 'Failed to get trial status',
        );
      }

      // Parse TrialStatusResponse from data
      final trialData = responseData.data;
      if (trialData == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'No data in response',
        );
      }

      // Parse and create TrialModel
      final trialModel = TrialModel.fromJson(trialData);

      // Update trialId in cache if available
      if (trialModel.trialId != null) {
        await cacheService.save(CacheKey.trialId, trialModel.trialId!);
      }

      return ResponseObject<TrialEntity>.success(trialModel);
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to get trial status: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<StudentCheckEntity>> checkStudentStatus() async {
    try {
      // Get deviceId from cache (required for checkStudentStatus)
      final deviceId = cacheService.get<String>(CacheKey.deviceId);

      if (deviceId == null || deviceId.isEmpty) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Device ID is required',
        );
      }

      // Build request body for checkStudentStatus
      final request = <String, dynamic>{'deviceId': deviceId};

      // Call checkStudentStatus endpoint
      final response = await studentService.checkStudentStatus(request);

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Invalid response format',
        );
      }

      // Ensure responseJson is a Map
      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      // Parse ResponseObject from JSON
      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? ErrorCodes.internalError,
          errorDetail:
              responseData.errorDetail ?? 'Failed to check student status',
        );
      }

      // Parse StudentCheckResponse from data
      final checkData = responseData.data;
      if (checkData == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'No data in response',
        );
      }

      // Parse and create StudentCheckModel
      final checkModel = StudentCheckModel.fromJson(checkData);

      return ResponseObject<StudentCheckEntity>.success(checkModel);
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to check student status: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<TrialEntity>> createTrial({
    required int grade,
    required List<String> learningGoals,
  }) async {
    try {
      // Get deviceId from cache (required for createTrial)
      final deviceId = cacheService.get<String>(CacheKey.deviceId);

      if (deviceId == null || deviceId.isEmpty) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Device ID is required',
        );
      }

      // Build request body for createTrial
      final request = <String, dynamic>{
        'deviceId': deviceId,
        'grade': grade,
        'learningGoals': learningGoals,
      };

      // Call createTrial endpoint
      final response = await studentService.createTrial(request);

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Invalid response format',
        );
      }

      // Ensure responseJson is a Map
      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      // Parse ResponseObject from JSON
      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? ErrorCodes.internalError,
          errorDetail: responseData.errorDetail ?? 'Failed to create trial',
        );
      }

      // Parse TrialStatusResponse from data
      final trialData = responseData.data;
      if (trialData == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'No data in response',
        );
      }

      // Parse and create TrialModel
      final trialModel = TrialModel.fromJson(trialData);

      // Save trialId to cache if available
      if (trialModel.trialId != null) {
        await cacheService.save(CacheKey.trialId, trialModel.trialId!);
      }

      // Save grade and learning goals to cache
      await cacheService.save(CacheKey.grade, grade);
      await cacheService.save(CacheKey.learningGoals, learningGoals);

      return ResponseObject<TrialEntity>.success(trialModel);
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to create trial: ${e.toString()}',
      );
    }
  }
}
