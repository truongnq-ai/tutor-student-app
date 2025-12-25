import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/learning_entity.dart';

part 'learning_plan_provider.g.dart';

@riverpod
class LearningPlan extends _$LearningPlan {
  @override
  Future<LearningPlanEntity?> build() async {
    return null;
  }

  Future<void> loadTodayPlan() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(learningRepositoryProvider).getTodayLearningPlan();

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

