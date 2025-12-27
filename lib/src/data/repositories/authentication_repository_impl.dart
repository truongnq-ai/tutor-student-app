import 'package:dio/dio.dart';

import '../../core/base/response_object.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/sign_up_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../models/login_model.dart';
import '../models/sign_up_model.dart';
import '../services/cache/cache_service.dart';
import '../services/network/services/auth_service.dart';
import '../services/network/services/student_service.dart';

final class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.studentService,
    required this.authService,
    required this.local,
  });

  final StudentService studentService;
  final AuthService authService;
  final CacheService local;

  @override
  Future<ResponseObject<SignUpResponseEntity>> register(
    SignUpRequestEntity data,
  ) async {
    try {
      final requestJson = data.toJson();
      final response = await studentService.register(requestJson);

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
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
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Registration failed',
        );
      }

      // Parse StudentResponse from data
      final studentData = responseData.data;
      if (studentData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      // Parse StudentResponse (userId, username)
      final userId = studentData['userId'] as String? ?? studentData['id'] as String?;
      final username = studentData['username'] as String?;

      if (userId == null || username == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Missing data in response',
        );
      }

      return ResponseObject.success(
        SignUpResponseModel(
          studentId: userId,
          username: username,
        ),
      );
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Registration failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<LoginResponseEntity>> login(
    LoginRequestEntity data,
  ) async {
    try {
      final model = LoginRequestModel.fromEntity(data);
      final response = await studentService.login(model.toJson());

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
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
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Login failed',
        );
      }

      // Parse AuthenticationResponse from data
      final authData = responseData.data;
      if (authData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      // Parse AuthenticationResponse (accessToken, refreshToken, tokenType, expiresIn, refreshTokenExpiresIn)
      final accessToken = authData['accessToken'] as String?;
      final refreshToken = authData['refreshToken'] as String?;
      final tokenType = authData['tokenType'] as String?;
      final expiresIn = authData['expiresIn'] as int?;
      final refreshTokenExpiresIn = authData['refreshTokenExpiresIn'] as int?;

      if (accessToken == null || refreshToken == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Missing tokens in response',
        );
      }

      // Save tokens
      await local.save(CacheKey.accessToken, accessToken);
      await local.save(CacheKey.refreshToken, refreshToken);

      // Save the session if the user has selected the "Remember Me" option
      if (data.shouldRemeber ?? false) {
        await _saveSession();
      }

      return ResponseObject.success(
        LoginResponseEntity(
          accessToken: accessToken,
          refreshToken: refreshToken,
          tokenType: tokenType,
          expiresIn: expiresIn,
          refreshTokenExpiresIn: refreshTokenExpiresIn,
        ),
      );
    } on DioException catch (e) {
      // Try to parse error response from backend if available
      if (e.response != null && e.response!.data != null) {
        try {
          final responseData = e.response!.data;
          if (responseData is Map<String, dynamic>) {
            final errorResponse = ResponseObject<Map<String, dynamic>>.fromJson(
              responseData,
              (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
            );
            return ResponseObject.error(
              errorCode: errorResponse.errorCode ?? _getErrorCodeFromStatusCode(e.response!.statusCode),
              errorDetail: errorResponse.errorDetail ?? _getDefaultErrorMessage(e),
            );
          }
        } catch (_) {
          // Fall through to default error handling
        }
      }
      
      // Return error with status code-based error code
      return ResponseObject.error(
        errorCode: _getErrorCodeFromStatusCode(e.response?.statusCode),
        errorDetail: _getDefaultErrorMessage(e),
      );
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Login failed: ${e.toString()}',
      );
    }
  }

  Future<void> _saveSession() async {
    await local.save(CacheKey.isLoggedIn, true);
  }

  /// Manages the "Remember Me" functionality.
  ///
  /// When [rememberMe] is null, retrieves the current setting from cache.
  /// When [rememberMe] has a value, updates the setting in cache.
  /// Returns the current or newly saved value, defaulting to false on errors.
  @override
  Future<bool> rememberMe({bool? rememberMe}) async {
    try {
      if (rememberMe == null) {
        return local.get<bool>(CacheKey.rememberMe) ?? false;
      }

      await local.save(CacheKey.rememberMe, rememberMe);

      return rememberMe;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ResponseObject<String>> forgotPassword(
    Map<String, dynamic> data,
  ) async {
    // TODO: implement forgotPassword
    return ResponseObject.error(
      errorCode: '5001',
      errorDetail: 'Forgot password not yet implemented',
    );
  }

  @override
  Future<ResponseObject<String>> resetPassword(
    Map<String, dynamic> data,
  ) async {
    // TODO: implement resetPassword
    return ResponseObject.error(
      errorCode: '5001',
      errorDetail: 'Reset password not yet implemented',
    );
  }

  @override
  Future<ResponseObject<String>> verifyOTP(
    Map<String, dynamic> data,
  ) async {
    // TODO: implement verifyOTP
    return ResponseObject.error(
      errorCode: '5001',
      errorDetail: 'Verify OTP not yet implemented',
    );
  }

  @override
  Future<ResponseObject<String>> resendOTP(
    Map<String, dynamic> data,
  ) async {
    // TODO: implement resendOTP
    return ResponseObject.error(
      errorCode: '5001',
      errorDetail: 'Resend OTP not yet implemented',
    );
  }

  @override
  Future<ResponseObject<Map<String, dynamic>>> oauthLogin(
    String provider,
    String idToken,
  ) async {
    try {
      final request = {
        'provider': provider,
        'token': idToken,
      };
      final response = await studentService.oauthLogin(request);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
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

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'OAuth login failed',
        );
      }

      final oauthResponse = responseData.data ?? {};
      
      // If tokens are returned (not requiresSetCredential), save them
      final requiresSetCredential = oauthResponse['requiresSetCredential'] as bool? ?? false;
      if (!requiresSetCredential) {
        final tokens = oauthResponse['tokens'] as Map<String, dynamic>?;
        if (tokens != null) {
          final accessToken = tokens['accessToken'] as String?;
          final refreshToken = tokens['refreshToken'] as String?;
          
          if (accessToken != null && refreshToken != null) {
            await local.save(CacheKey.accessToken, accessToken);
            await local.save(CacheKey.refreshToken, refreshToken);
            await local.save(CacheKey.isLoggedIn, true);
          }
        }
      }

      return ResponseObject.success(oauthResponse);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'OAuth login failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<SignUpResponseEntity>> setCredential(
    String studentId,
    String username,
    String password,
    String confirmPassword,
  ) async {
    try {
      final request = {
        'username': username,
        'password': password,
        'confirmPassword': confirmPassword,
      };
      final response = await studentService.setCredential(studentId, request);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
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

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Set credential failed',
        );
      }

      final studentData = responseData.data;
      if (studentData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final userId = studentData['userId'] as String? ?? studentData['id'] as String?;
      final usernameFromResponse = studentData['username'] as String?;

      if (userId == null || usernameFromResponse == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Missing data in response',
        );
      }

      return ResponseObject.success(
        SignUpResponseModel(
          studentId: userId,
          username: usernameFromResponse,
        ),
      );
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Set credential failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<void>> logout() async {
    try {
      // Call logout API endpoint
      final response = await authService.logout();
      final responseJson = response.data;
      
      // Clear local tokens regardless of API response
      await local.remove([
        CacheKey.isLoggedIn,
        CacheKey.rememberMe,
        CacheKey.accessToken,
        CacheKey.refreshToken,
      ]);

      if (responseJson != null) {
        // Ensure responseJson is a Map
        final responseMap = responseJson is Map<String, dynamic>
            ? responseJson
            : <String, dynamic>{};
        
        // Parse ResponseObject from JSON
        final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
          responseMap,
          (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
        );

        if (!responseData.isSuccess) {
          return ResponseObject.error(
            errorCode: responseData.errorCode ?? '5001',
            errorDetail: responseData.errorDetail ?? 'Logout failed',
          );
        }
      }

      return ResponseObject.success(null);
    } catch (e) {
      // Even if API call fails, clear local tokens
      await local.remove([
        CacheKey.isLoggedIn,
        CacheKey.rememberMe,
        CacheKey.accessToken,
        CacheKey.refreshToken,
      ]);
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Logout failed: ${e.toString()}',
      );
    }
  }

  /// Get error code from HTTP status code
  String _getErrorCodeFromStatusCode(int? statusCode) {
    if (statusCode == null) {
      return '5001';
    }
    
    return switch (statusCode) {
      400 => '2001', // Validation error
      401 => '1001', // Unauthorized
      403 => '1003', // Forbidden
      404 => '3001', // Not found
      409 => '3002', // Conflict
      500 => '5001', // Internal error
      502 || 503 || 504 => '4001', // Service unavailable
      _ => '5001', // Default to internal error
    };
  }

  /// Get default error message from DioException
  /// 
  /// Returns generic error messages that will be mapped to localized messages
  /// in the UI layer based on errorCode.
  String _getDefaultErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;
    
    // For 401, return generic message that will be mapped to localized message
    if (statusCode == 401) {
      return 'Invalid credentials';
    }
    
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => 'Connection timeout',
      DioExceptionType.connectionError => 'Network connection error',
      DioExceptionType.badResponse => 'Server error',
      DioExceptionType.badCertificate => 'Certificate error',
      DioExceptionType.cancel => 'Request cancelled',
      DioExceptionType.unknown => 'Unexpected error',
    };
  }
}
