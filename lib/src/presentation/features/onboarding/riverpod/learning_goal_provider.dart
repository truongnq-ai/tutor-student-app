import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Set<String> getSelectedGoals() {
    return state.value ?? {};
  }
}

