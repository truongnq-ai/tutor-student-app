import '../../core/base/repository.dart';
import '../../core/base/response_object.dart';
import '../entities/login_entity.dart';
import '../entities/sign_up_entity.dart';

abstract base class AuthenticationRepository extends Repository {
  Future<ResponseObject<SignUpResponseEntity>> register(SignUpRequestEntity data);

  Future<ResponseObject<LoginResponseEntity>> login(LoginRequestEntity data);

  Future<bool> rememberMe({bool? rememberMe});

  Future<ResponseObject<String>> forgotPassword(Map<String, dynamic> data);

  Future<ResponseObject<String>> resetPassword(Map<String, dynamic> data);

  Future<ResponseObject<String>> verifyOTP(Map<String, dynamic> data);

  Future<ResponseObject<String>> resendOTP(Map<String, dynamic> data);

  Future<ResponseObject<void>> logout();
}
