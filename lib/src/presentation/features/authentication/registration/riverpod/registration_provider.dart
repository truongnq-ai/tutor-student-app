import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/failure.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/sign_up_entity.dart';

part 'registration_provider.g.dart';

@riverpod
class Registration extends _$Registration {
  @override
  AsyncValue<SignUpResponseEntity?> build() {
    return const AsyncValue.data(null);
  }

  void register({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final request = SignUpRequestEntity(
        name: name,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );

      final response = await ref.read(registerUseCaseProvider).call(request);

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } on DioException catch (e, stackTrace) {
      // Parse DioException to get user-friendly message
      final failure = Failure.mapExceptionToFailure(e);
      String userMessage;
      
      // Handle specific HTTP status codes
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        switch (statusCode) {
          case 502:
          case 503:
          case 504:
            userMessage = 'Máy chủ đang bảo trì hoặc tạm thời không khả dụng. Vui lòng thử lại sau.';
            break;
          case 500:
            userMessage = 'Lỗi máy chủ. Vui lòng thử lại sau.';
            break;
          case 400:
            userMessage = failure.message;
            break;
          case 401:
            userMessage = 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
            break;
          case 403:
            userMessage = 'Bạn không có quyền thực hiện thao tác này.';
            break;
          case 404:
            userMessage = 'Không tìm thấy dịch vụ. Vui lòng kiểm tra lại.';
            break;
          default:
            userMessage = failure.message;
        }
      } else {
        // Network or connection errors
        userMessage = failure.message;
      }
      
      state = AsyncValue.error(
        Exception(userMessage),
        stackTrace,
      );
    } catch (e, stackTrace) {
      // Handle other exceptions
      final failure = Failure.mapExceptionToFailure(e);
      state = AsyncValue.error(
        Exception(failure.message),
        stackTrace,
      );
    }
  }
}

