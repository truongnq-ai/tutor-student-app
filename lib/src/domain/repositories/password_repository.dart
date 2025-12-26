import '../../core/base/response_object.dart';

abstract class PasswordRepository {
  Future<ResponseObject<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}

