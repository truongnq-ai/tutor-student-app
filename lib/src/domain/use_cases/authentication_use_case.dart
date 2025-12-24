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
