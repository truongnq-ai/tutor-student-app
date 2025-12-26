import '../../core/base/response_object.dart';
import '../../domain/repositories/password_repository.dart';
import '../services/network/services/password_service.dart';

final class PasswordRepositoryImpl extends PasswordRepository {
  PasswordRepositoryImpl({
    required this.passwordService,
  });

  final PasswordService passwordService;

  @override
  Future<ResponseObject<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final requestBody = <String, dynamic>{
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };

      final response = await passwordService.changePassword(requestBody);

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

      final responseData = ResponseObject<void>.fromJson(
        responseMap,
        (data) => null,
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to change password',
        );
      }

      return ResponseObject.success(null);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to change password: ${e.toString()}',
      );
    }
  }
}

