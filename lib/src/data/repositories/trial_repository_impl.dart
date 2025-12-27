import '../../core/base/response_object.dart';
import '../../core/constants/error_codes.dart';
import '../../domain/entities/trial_entity.dart';
import '../../domain/repositories/trial_repository.dart';
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
  Future<ResponseObject<TrialEntity>> startTrial() async {
    try {
      // Get deviceId from cache (required for checkTrial)
      final deviceId = cacheService.get<String>(CacheKey.deviceId);
      
      if (deviceId == null || deviceId.isEmpty) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Device ID is required',
        );
      }

      // Build request body for checkTrial (deviceId-based)
      final request = <String, dynamic>{
        'deviceId': deviceId,
      };

      // Use checkTrial endpoint (backend decides NEW/ACTIVE/EXPIRED/CONSUMED)
      final response = await studentService.checkTrial(request);

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
          errorDetail: responseData.errorDetail ?? 'Failed to start trial',
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

      return ResponseObject<TrialEntity>.success(trialModel);
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to start trial: ${e.toString()}',
      );
    }
  }

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
}

