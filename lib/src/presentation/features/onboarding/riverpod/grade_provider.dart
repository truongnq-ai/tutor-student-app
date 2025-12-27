import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  int? getSelectedGrade() {
    return state.value;
  }
}

