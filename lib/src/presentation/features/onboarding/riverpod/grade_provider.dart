import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/constants/error_codes.dart';
import '../../../../core/di/dependency_injection.dart';

part 'grade_provider.g.dart';

@riverpod
class GradeSelection extends _$GradeSelection {
  @override
  AsyncValue<int?> build() {
    // Load grade from API on initialization
    _loadGrade();
    return const AsyncValue<int?>.data(null);
  }

  Future<void> _loadGrade() async {
    try {
      final repository = ref.read(onboardingRepositoryProvider);
      
      // Add timeout (5 seconds)
      final response = await repository.getGrade().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // On timeout, throw exception to be caught by outer catch
          throw TimeoutException(
            'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.',
            const Duration(seconds: 5),
          );
        },
      );

      if (response.isSuccess && response.data != null) {
        state = AsyncValue<int?>.data(response.data);
      } else {
        // If API fails, keep current state (might be null or cached value)
        // Don't show error for initial load
      }
    } catch (e) {
      // On error, keep current state (graceful degradation)
      // Don't show error for initial load
    }
  }

  Future<void> selectGrade(int grade) async {
    if (state.isLoading) return;

    // Validate grade (only 6 or 7)
    if (grade != 6 && grade != 7) {
      state = AsyncValue<int?>.error(
        Exception('Lớp học không hợp lệ. Chỉ có thể chọn lớp 6 hoặc 7.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue<int?>.loading();

    try {
      final repository = ref.read(onboardingRepositoryProvider);
      
      // Add timeout (5 seconds)
      final response = await repository.saveGrade(grade).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException(
            'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.',
            const Duration(seconds: 5),
          );
        },
      );

      if (!response.isSuccess) {
        final errorCode = response.errorCode ?? ErrorCodes.internalError;
        String errorMessage = response.errorDetail ?? 'Không thể lưu lớp học. Vui lòng thử lại.';
        
        // Handle specific error codes
        if (errorCode == ErrorCodes.gradeInvalid) {
          errorMessage = 'Lớp học không hợp lệ. Chỉ có thể chọn lớp 6 hoặc 7.';
        } else if (errorCode == ErrorCodes.trialNotFound) {
          errorMessage = 'Không tìm thấy trial. Vui lòng bắt đầu trial trước.';
        } else if (errorCode == ErrorCodes.missingRequestParameter) {
          errorMessage = 'Thiếu thông tin cần thiết. Vui lòng thử lại.';
        }
        
        state = AsyncValue<int?>.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return;
      }

      // Update state with saved grade
      state = AsyncValue<int?>.data(grade);
    } on TimeoutException catch (e, stackTrace) {
      state = AsyncValue<int?>.error(
        Exception(e.message ?? 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.'),
        stackTrace,
      );
    } on Failure catch (e, stackTrace) {
      String errorMessage = 'Không thể lưu lớp học. Vui lòng thử lại.';
      if (e.type == FailureType.timeout) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      } else if (e.type == FailureType.network) {
        errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue<int?>.error(Exception(errorMessage), stackTrace);
    } catch (e, stackTrace) {
      String errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
      if (e.toString().contains('timeout') || e.toString().contains('Timeout')) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue<int?>.error(Exception(errorMessage), stackTrace);
    }
  }

  int? getSelectedGrade() {
    return state.value;
  }
}

