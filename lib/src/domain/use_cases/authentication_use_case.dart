import '../../core/base/response_object.dart';
import '../entities/login_entity.dart';
import '../entities/sign_up_entity.dart';
import '../repositories/authentication_repository.dart';

final class RegisterUseCase {
  RegisterUseCase(this.repository);

  final AuthenticationRepository repository;

  Future<ResponseObject<SignUpResponseEntity>> call(
    SignUpRequestEntity request,
  ) async {
    return repository.register(request);
  }
}

final class LoginUseCase {
  LoginUseCase(this.repository);

  final AuthenticationRepository repository;

  Future<ResponseObject<LoginResponseEntity>> call({
    required String username,
    required String password,
    bool? shouldRemember,
  }) async {
    final request = LoginRequestEntity(
      username: username,
      password: password,
      shouldRemeber: shouldRemember,
    );

    return repository.login(request);
  }
}

final class LogoutUseCase {
  LogoutUseCase(this.repository);

  final AuthenticationRepository repository;

  Future<ResponseObject<void>> call() async {
    return repository.logout();
  }
}

final class OAuthLoginUseCase {
  OAuthLoginUseCase(this.repository);

  final AuthenticationRepository repository;

  Future<ResponseObject<Map<String, dynamic>>> call({
    required String provider,
    required String idToken,
  }) async {
    return repository.oauthLogin(provider, idToken);
  }
}

final class SetCredentialUseCase {
  SetCredentialUseCase(this.repository);

  final AuthenticationRepository repository;

  Future<ResponseObject<SignUpResponseEntity>> call({
    required String studentId,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    return repository.setCredential(studentId, username, password, confirmPassword);
  }
}
