import '../../../core/base/response_object.dart';
import '../../../core/constants/error_codes.dart';
import '../../../domain/repositories/parent_linking_repository.dart';
import '../../services/cache/cache_service.dart';
import '../../services/network/services/linking_service.dart';

final class ParentLinkingRepositoryImpl extends ParentLinkingRepository {
  ParentLinkingRepositoryImpl({
    required this.linkingService,
    required this.cacheService,
  });

  final LinkingService linkingService;
  final CacheService cacheService;

  /// Get trialId from cache (required for parent linking)
  Future<String?> _getTrialId() async {
    return cacheService.get<String>(CacheKey.trialId);
  }

  @override
  Future<ResponseObject<void>> requestOtp(String phoneNumber) async {
    try {
      final trialId = await _getTrialId();
      if (trialId == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.missingRequestParameter,
          errorDetail: 'Trial ID is required for parent linking',
        );
      }

      // Build request body
      final request = <String, dynamic>{
        'phoneNumber': phoneNumber,
      };

      final response = await linkingService.requestOtp(trialId, request);

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
      final responseData = ResponseObject<dynamic>.fromJson(
        responseMap,
        (data) => data,
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        final errorCode = responseData.errorCode ?? ErrorCodes.internalError;
        if (errorCode == ErrorCodes.trialNotFound) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Trial not found',
          );
        }
        if (errorCode == ErrorCodes.rateLimitExceeded) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Rate limit exceeded. Please try again later.',
          );
        }
        return ResponseObject.error(
          errorCode: errorCode,
          errorDetail: responseData.errorDetail ?? 'Failed to request OTP',
        );
      }

      return ResponseObject.success(null);
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to request OTP: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<Map<String, dynamic>>> verifyOtp(
    String phoneNumber,
    String otpCode,
  ) async {
    try {
      final trialId = await _getTrialId();
      if (trialId == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.missingRequestParameter,
          errorDetail: 'Trial ID is required for parent linking',
        );
      }

      // Build request body
      final request = <String, dynamic>{
        'phoneNumber': phoneNumber,
        'otpCode': otpCode,
      };

      final response = await linkingService.verifyOtp(trialId, request);

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
        final errorCode = responseData.errorCode ?? ErrorCodes.internalError;
        if (errorCode == ErrorCodes.otpVerificationError || errorCode == ErrorCodes.otpInvalid) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Invalid OTP code',
          );
        }
        if (errorCode == ErrorCodes.trialNotFound) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Trial not found',
          );
        }
        return ResponseObject.error(
          errorCode: errorCode,
          errorDetail: responseData.errorDetail ?? 'Failed to verify OTP',
        );
      }

      // Parse ParentLinkVerifyOtpResponse from data
      final verifyData = responseData.data;
      if (verifyData == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'No data in response',
        );
      }

      // Extract username, password, and dashboardLink
      final username = verifyData['username'] as String?;
      final password = verifyData['password'] as String?;
      final dashboardLink = verifyData['dashboardLink'] as String?;

      if (username == null || password == null || dashboardLink == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Missing data in response',
        );
      }

      return ResponseObject.success({
        'username': username,
        'password': password,
        'dashboardLink': dashboardLink,
      });
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to verify OTP: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<void>> resendOtp(String phoneNumber) async {
    try {
      final trialId = await _getTrialId();
      if (trialId == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.missingRequestParameter,
          errorDetail: 'Trial ID is required for parent linking',
        );
      }

      // Build request body
      final request = <String, dynamic>{
        'phoneNumber': phoneNumber,
      };

      final response = await linkingService.resendOtp(trialId, request);

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
      final responseData = ResponseObject<dynamic>.fromJson(
        responseMap,
        (data) => data,
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        final errorCode = responseData.errorCode ?? ErrorCodes.internalError;
        if (errorCode == ErrorCodes.trialNotFound) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Trial not found',
          );
        }
        if (errorCode == ErrorCodes.rateLimitExceeded) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Rate limit exceeded. Please try again later.',
          );
        }
        return ResponseObject.error(
          errorCode: errorCode,
          errorDetail: responseData.errorDetail ?? 'Failed to resend OTP',
        );
      }

      return ResponseObject.success(null);
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to resend OTP: ${e.toString()}',
      );
    }
  }
}

