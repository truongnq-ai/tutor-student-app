import '../../core/base/response_object.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/sign_up_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../models/login_model.dart';
import '../services/cache/cache_service.dart';
import '../services/network/services/student_service.dart';

final class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.studentService,
    required this.local,
  });

  final StudentService studentService;
  final CacheService local;

  @override
  Future<ResponseObject<SignUpResponseEntity>> register(
    SignUpRequestEntity data,
  ) async {
    try {
      // TODO: Implement register with StudentService
      // For now, return unimplemented error
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Register not yet implemented',
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
      final responseData = response.data;
      if (responseData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      // Check if response is successful
      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Login failed',
        );
      }

      // Parse login response data
      final loginData = responseData.data;
      if (loginData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      // Map to entity (assuming loginData is Map with accessToken, refreshToken)
      final accessToken = loginData['accessToken'] as String? ??
          loginData['token'] as String?;
      final refreshToken = loginData['refreshToken'] as String?;

      if (accessToken == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No access token in response',
        );
      }

      // Save tokens
      await local.save(CacheKey.accessToken, accessToken);
      if (refreshToken != null) {
        await local.save(CacheKey.refreshToken, refreshToken);
      }

      // Save the session if the user has selected the "Remember Me" option
      if (data.shouldRemeber ?? false) {
        await _saveSession();
      }

      return ResponseObject.success(
        LoginResponseEntity(accessToken: accessToken),
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
  Future<ResponseObject<void>> logout() async {
    try {
      await local.remove([CacheKey.isLoggedIn, CacheKey.rememberMe]);
      // TODO: Call logout API endpoint
      return ResponseObject.success(null);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Logout failed: ${e.toString()}',
      );
    }
  }
}
