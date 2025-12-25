import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/constants/error_codes.dart';
import '../../../../core/di/dependency_injection.dart';

part 'learning_goal_provider.g.dart';

@riverpod
class LearningGoals extends _$LearningGoals {
  @override
  AsyncValue<Set<String>> build() {
    // Load learning goals from API on initialization
    _loadLearningGoals();
    return const AsyncValue.data({});
  }

  Future<void> _loadLearningGoals() async {
    try {
      final repository = ref.read(onboardingRepositoryProvider);
      
      // Add timeout (5 seconds)
      final response = await repository.getLearningGoals().timeout(
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
        state = AsyncValue<Set<String>>.data(response.data!);
      } else {
        // If API fails, keep current state (might be empty or cached value)
        // Don't show error for initial load
      }
    } catch (e) {
      // On error, keep current state (graceful degradation)
      // Don't show error for initial load
    }
  }

  Future<void> saveLearningGoals(Set<String> goals) async {
    if (state.isLoading) return;

    // Validate: minimum 1 selection required
    if (goals.isEmpty) {
      state = AsyncValue<Set<String>>.error(
        Exception('Vui lòng chọn ít nhất một mục tiêu học tập.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue<Set<String>>.loading();

    try {
      final repository = ref.read(onboardingRepositoryProvider);
      
      // Add timeout (5 seconds)
      final response = await repository.saveLearningGoals(goals).timeout(
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
        String errorMessage = response.errorDetail ?? 'Không thể lưu mục tiêu học tập. Vui lòng thử lại.';
        
        // Handle specific error codes
        if (errorCode == ErrorCodes.learningGoalsEmpty) {
          errorMessage = 'Vui lòng chọn ít nhất một mục tiêu học tập.';
        } else if (errorCode == ErrorCodes.trialNotFound) {
          errorMessage = 'Không tìm thấy trial. Vui lòng bắt đầu trial trước.';
        } else if (errorCode == ErrorCodes.missingRequestParameter) {
          errorMessage = 'Thiếu thông tin cần thiết. Vui lòng thử lại.';
        }
        
        state = AsyncValue<Set<String>>.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return;
      }

      // Update state with saved goals
      state = AsyncValue<Set<String>>.data(goals);
    } on TimeoutException catch (e, stackTrace) {
      state = AsyncValue<Set<String>>.error(
        Exception(e.message ?? 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.'),
        stackTrace,
      );
    } on Failure catch (e, stackTrace) {
      String errorMessage = 'Không thể lưu mục tiêu học tập. Vui lòng thử lại.';
      if (e.type == FailureType.timeout) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      } else if (e.type == FailureType.network) {
        errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue<Set<String>>.error(Exception(errorMessage), stackTrace);
    } catch (e, stackTrace) {
      String errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
      if (e.toString().contains('timeout') || e.toString().contains('Timeout')) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue<Set<String>>.error(Exception(errorMessage), stackTrace);
    }
  }

  Set<String> getSelectedGoals() {
    return state.value ?? {};
  }
}

